//
//  NUSLineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//

import SwiftUI

struct NUSLineSelectionView: View {
    @StateObject private var viewModel = NUSActiveBusLineListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading available lines...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.availableBusLines.isEmpty {
                    Text("No active NUS bus lines found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.availableBusLines) { line in
                        NavigationLink(destination: NUSPublicBusStopListView(line: line)) {
                            Text(line.lineName)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("NUS Bus Lines")
            .task {
                await viewModel.loadAvailableLines()
            }
        }
    }
}
