import SwiftUI

struct BusStopArrivalView: View {
    let busStopId: String
    
    @StateObject private var viewModel = BusStopArrivalViewModel()
    
    private var arrivalMinutes: [Int] {
        viewModel.arrivalTimes.map { $0.minutes }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView("Loading arrival times...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Bus Stop: \(viewModel.stopName)")
                    .font(.headline)
                
                if arrivalMinutes.isEmpty {
                    Text("No upcoming arrivals.")
                        .foregroundColor(.secondary)
                } else {
                    List(arrivalMinutes, id: \.self) { minutes in
                        Text("\(minutes) min")
                    }
                }

                Toggle("Notify me when bus is coming soon", isOn: $viewModel.notifyWhenSoon)
                    .padding(.horizontal)
                    .onChange(of: viewModel.notifyWhenSoon) { enabled in
                        viewModel.toggleNotification(enabled)
                    }

                if viewModel.notifyWhenSoon {
                    Stepper(value: $viewModel.notificationLeadTime, in: 1...30, step: 1) {
                        Text("Notify \(viewModel.notificationLeadTime) min before arrival")
                    }
                    .padding(.horizontal)
                    .onChange(of: viewModel.notificationLeadTime) { _ in
                        viewModel.rescheduleNotificationIfNeeded()
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Bus Arrivals")
        .task {
            await viewModel.fetchArrivalTimes(for: busStopId)
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}
