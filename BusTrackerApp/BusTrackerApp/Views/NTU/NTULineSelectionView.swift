//
//  NTULineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//  Updated for NTU-specific logic
//

import SwiftUI

struct NTULineSelectionView: View {
    @StateObject private var viewModel = NTUActiveBusLinesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading active lines...")
                } else if !viewModel.activeLines.isEmpty {
                    List(viewModel.activeLines, id: \.self) { line in
                        NavigationLink(destination: NTUBusLineDetailView(line: line)) {
                            Text(line.rawValue.capitalized)
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    Text("No active lines found")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("NTU Bus Lines")
        }
        .task {
            await viewModel.fetchActiveLines()
        }
    }
}
