//
//  ContentView.swift
//  NUSBusAPI
//
//  Created by Ava on 12/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        BusArrivalTestView()
        ActiveBusTestView()
        .padding()
    }
}

#Preview {
    ContentView()
}
