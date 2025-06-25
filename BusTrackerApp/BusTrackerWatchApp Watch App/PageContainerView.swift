//
//  PageContainerView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 22/6/25.
//


import SwiftUI

struct PageContainerView: View {
    @State private var currentPage = 1 // Start with NTU in the center

    var body: some View {
        TabView(selection: $currentPage) {
            NUSLineSelectionView()
                .tag(0)

            NTULineSelectionView()
                .tag(1)

            SMUPublicBusStopSelectionView()
                .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page)
    }
}
