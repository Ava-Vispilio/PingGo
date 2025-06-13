//
//  NTUWatchLineSelectionVew.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on
//
// Displays a list of NTU's active bus lines (for user to select)

import SwiftUI

struct NTUWatchLineSelectionView: View {
    @StateObject private var viewModel = NTUWatchLineSelectionViewModel()

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
                        NavigationLink(destination: NTUWatchBusStopListView(line: line)) {
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
