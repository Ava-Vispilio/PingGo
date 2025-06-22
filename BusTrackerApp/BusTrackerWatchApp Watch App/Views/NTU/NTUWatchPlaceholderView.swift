//
//  NTUWatchPlaceholderView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 22/6/25.
//


import SwiftUI

struct NTUWatchPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("NTU")
                .font(.title2)
                .bold()
            Text("NTU section coming soon.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
