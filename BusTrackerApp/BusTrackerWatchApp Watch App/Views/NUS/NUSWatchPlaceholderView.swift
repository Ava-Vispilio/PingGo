//
//  NUSWatchPlaceholderView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 22/6/25.
//


import SwiftUI

struct NUSWatchPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("NUS")
                .font(.title2)
                .bold()
            Text("NUS section coming soon.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
