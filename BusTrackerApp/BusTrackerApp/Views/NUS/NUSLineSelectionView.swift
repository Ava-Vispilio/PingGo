//
//  NUSLineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays a list of NUS's (internal & public) bus routes (users to pick a bus route)

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
            // Uncomment once NUS API ready and edit accordingly (can remove Group above)
//            List {
//                if !viewModel.internalActiveLines.isEmpty {     // check whether viewmodel has .internalActiveLines
//                    Section(header: Text("NUS Shuttle Buses")) {
//                        ForEach(viewModel.internalActiveLines, id: \.self) { line in
//                            NavigationLink(destination: NUSInternalBusLineDetailView(line: line)) { // rename to wtv the file name is
//                                Text(line.rawValue.capitalized)
//                            }
//                        }
//                    }
//                }
//                
//                if !viewModel.publicActiveLines.isEmpty {   // check if viewmodel has .publicActiveLines
//                    Section(header: Text("NUS Public Buses")) {
//                        ForEach(viewModel.publicActiveLines, id: \.self) { lineName in
//                            NavigationLink(destination: NUSPublicBusStopListView(line: line)) {
//                                Text(line.lineName)
//                            }
//                        }
//                    }
//                }
//                
//                if viewModel.internalActiveLines.isEmpty && viewModel.publicActiveLines.isEmpty && !viewModel.isLoading {
//                    Text("No active lines found.")
//                        .foregroundColor(.secondary)
//                }
//            }
            .navigationTitle("NUS Bus Lines")
//            .overlay {
//                if viewModel.isLoading {
//                    ProgressView("Loading active lines...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                }
//            }
            .task {
                await viewModel.loadAvailableLines()
            }
        }
    }
}
