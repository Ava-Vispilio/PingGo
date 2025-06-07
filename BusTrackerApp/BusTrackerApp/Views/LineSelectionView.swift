//
//  LineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 2/6/25.
//

import SwiftUI

struct LineSelectionView: View {
    @StateObject private var viewModel = ActiveBusLinesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading active lines...")
                } else if !viewModel.activeLines.isEmpty {
                    List(viewModel.activeLines, id: \.self) { line in
                        NavigationLink(destination: BusLineDetailView(line: line)) {
                            Text(line.rawValue.capitalized)
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    Text("No active lines found")
                }
            }
            .navigationTitle("Select Bus Line")
        }
        .task {
            await viewModel.fetchActiveLines()
        }
    }
}
