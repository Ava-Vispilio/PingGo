//
//  NTULineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 24/6/25.
//
// Shows a list of currently active NTU bus lines, divided into two sections: internal shuttle buses and public buses

import SwiftUI

struct NTULineSelectionView: View {
    @StateObject private var viewModel = NTUActiveBusLinesViewModel()

    var body: some View {
        NavigationView {
            List {
                // NTU Shuttle Buses Section
                if !viewModel.internalActiveLines.isEmpty {
                    Section(header: Text("NTU Shuttle Buses")) {
                        ForEach(viewModel.internalActiveLines, id: \.self) { line in
                            NavigationLink(destination: NTUInternalBusLineDetailView(line: line)) {
                                Text(line.rawValue.capitalized)
                            }
                        }
                    }
                }

                // NTU Public Buses Section
                if !viewModel.publicActiveLines.isEmpty {
                    Section(header: Text("NTU Public Buses")) {
                        ForEach(viewModel.publicActiveLines, id: \.self) { lineName in
                            NavigationLink(destination: NTUPublicBusLineDetailView(lineName: lineName)) {
                                Text(lineName)
                            }
                        }
                    }
                }

                // Empty state if both are unavailable
                if viewModel.internalActiveLines.isEmpty &&
                    viewModel.publicActiveLines.isEmpty &&
                    !viewModel.isLoading {
                    Section {
                        Text("No active NTU lines found.")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("NTU Bus Lines")
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading active lines…")
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .task {
                print("Loading available NTU lines...")
                await viewModel.fetchActiveLines()
                print("Finished loading all NTU lines.")
                print("Internal Active Lines: \(viewModel.internalActiveLines.map { $0.rawValue })")
                print("Public Active Lines: \(viewModel.publicActiveLines)")
            }
        }
    }
}
