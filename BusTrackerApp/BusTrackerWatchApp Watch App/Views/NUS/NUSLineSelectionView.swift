//
//  NUSLineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 23/6/25.
//
//  Displays a list of NUS's (internal & public) bus routes (users to pick a bus route)

import SwiftUI

struct NUSLineSelectionView: View {
    @StateObject private var viewModel = NUSActiveBusLineListViewModel()

    var body: some View {
        NavigationView {
            List {
                // Internal Shuttle Buses Section
                if !viewModel.internalActiveLines.isEmpty {
                    Section(header: Text("NUS Shuttle Buses")) {
                        ForEach(viewModel.internalActiveLines, id: \.self) { line in
                            NavigationLink(destination: NUSInternalBusLineDetailView(line: line)) {
                                Text(line.name)
                            }
                        }
                    }
                }

                // Public Buses Section
                if !viewModel.publicActiveLines.isEmpty {
                    Section(header: Text("NUS Public Buses")) {
                        ForEach(viewModel.publicActiveLines, id: \.lineName) { line in
                            NavigationLink(destination: NUSPublicBusStopListView(line: line)) {
                                Text(line.lineName)
                            }
                        }
                    }
                }

                // Empty state message (if both empty)
                if viewModel.internalActiveLines.isEmpty &&
                    viewModel.publicActiveLines.isEmpty &&
                    !viewModel.isLoading {
                    Section {
                        Text("No active NUS bus lines found.")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("NUS Bus Lines")
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading active lines...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .task {
                print("Loading available NUS lines...")
                await viewModel.loadAvailableLines()
                print("Finished loading all NUS lines.")
                print("Internal Active Lines: \(viewModel.internalActiveLines.map { $0.code })")
                print("Public Active Lines: \(viewModel.publicActiveLines.map { $0.lineName })")
            }
        }
    }
}
