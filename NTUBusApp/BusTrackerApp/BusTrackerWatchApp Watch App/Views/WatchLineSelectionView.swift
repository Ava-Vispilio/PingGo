import SwiftUI

struct WatchLineSelectionView: View {
    @StateObject private var viewModel = WatchLineSelectionViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading lines…")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else if viewModel.activeLines.isEmpty {
                    Text("No active lines.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.activeLines, id: \.self) { line in
                        NavigationLink(destination: WatchBusStopListView(line: line)) {
                            Text(line.rawValue.capitalized)
                        }
                    }
                }
            }
            .navigationTitle("Select Line")
            .onAppear {
                Task {
                    await viewModel.fetchActiveLines()
                }
            }
        }
    }
}
