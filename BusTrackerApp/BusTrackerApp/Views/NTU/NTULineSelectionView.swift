//
//  NTULineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//
// Displays a list of NTU's active bus routes (to select a route)

import SwiftUI

struct NTULineSelectionView: View {
    @StateObject private var viewModel = NTUActiveBusLinesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                if !viewModel.internalActiveLines.isEmpty {
                    Section(header: Text("NTU Shuttle Buses")) {
                        ForEach(viewModel.internalActiveLines, id: \.self) { line in
                            NavigationLink(destination: NTUInternalBusLineDetailView(line: line)) {
                                Text(line.rawValue.capitalized)
                            }
                        }
                    }
                }
                
                if !viewModel.publicActiveLines.isEmpty {
                    Section(header: Text("NTU Public Buses")) {
                        ForEach(viewModel.publicActiveLines, id: \.self) { lineName in
                            NavigationLink(destination: NTUPublicBusLineDetailView(lineName: lineName)) {
                                Text(lineName.capitalized)
                            }
                        }
                    }
                }
                
                if viewModel.internalActiveLines.isEmpty && viewModel.publicActiveLines.isEmpty && !viewModel.isLoading {
                    Text("No active lines found.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("NTU Bus Lines")
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading active lines...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .task {
                await viewModel.fetchActiveLines()
            }
        }
    }
}
