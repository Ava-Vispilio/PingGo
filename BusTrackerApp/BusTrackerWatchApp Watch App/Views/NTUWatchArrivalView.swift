import SwiftUI
import WatchKit

struct NTUWatchArrivalView: View {
    let busStop: NTUInternalBusStop
    @StateObject private var viewModel = NTUWatchArrivalViewModel()
    @State private var selectedReminderOffset = 2
    @State private var showReminderOptions = false

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else if viewModel.arrivalTimes.isEmpty {
                Text("No buses arriving soon.")
            } else {
                List {
                    ForEach(viewModel.arrivalTimes.indices, id: \.self) { index in
                        let time = viewModel.arrivalTimes[index]
                        VStack(alignment: .leading) {
                            Text("Arriving in \(time.minutes) min")

                            if index == 0 {
                                Button("Remind Me") {
                                    showReminderOptions = true
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.mini)
                                .font(.callout)
                                .sheet(isPresented: $showReminderOptions) {
                                    reminderPicker()
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(busStop.displayName)
        .task {
            await viewModel.fetchArrivalTimes(for: busStop.id)
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }

    @ViewBuilder
    private func reminderPicker() -> some View {
        VStack {
            Text("Remind me before:")
                .font(.headline)

            Picker("Minutes before", selection: $selectedReminderOffset) {
                ForEach(1..<11) { minutes in
                    Text("\(minutes) min").tag(minutes)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)

            Button("Set Reminder") {
                viewModel.notificationLeadTime = selectedReminderOffset
                viewModel.toggleNotification(true)
                showReminderOptions = false
                WKInterfaceDevice.current().play(.success)
            }
            .padding(.top)
        }
    }
}
