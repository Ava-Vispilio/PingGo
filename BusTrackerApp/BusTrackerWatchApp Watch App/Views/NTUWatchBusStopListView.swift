import SwiftUI

struct NTUWatchBusStopListView: View {
    let line: BusRouteColor
    @StateObject private var viewModel = NTUWatchBusStopListViewModel()
    @State private var selectedStop: NTUBusStop?

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading stops…")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else if viewModel.stops.isEmpty {
                Text("No stops found.")
                    .foregroundColor(.gray)
            } else {
                List(viewModel.stops) { stop in
                    Button {
                        selectedStop = stop
                    } label: {
                        Text(stop.name)
                            .lineLimit(1)
                    }
                }
                .navigationDestination(isPresented: Binding(
                    get: { selectedStop != nil },
                    set: { if !$0 { selectedStop = nil } }
                )) {
                    if let stop = selectedStop {
                        NTUWatchArrivalView(busStop: stop)
                    }
                }
            }
        }
        .navigationTitle(line.rawValue.capitalized)
        .task {
            await viewModel.fetchStops(for: line)
        }
    }
}
