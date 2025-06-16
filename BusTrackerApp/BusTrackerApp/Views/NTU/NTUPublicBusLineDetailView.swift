//
//  NTUPublicBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays a list of NTU's public bus stops (to choose from) for a selected bus route

// White background, grey list
import SwiftUI

struct NTUPublicBusLineDetailView: View {
    let lineName: String
    @StateObject private var viewModel = NTUPublicBusLineDetailViewModel()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // White background

            VStack(alignment: .leading, spacing: 16) {
                if viewModel.isLoading {
                    ProgressView("Loading stops...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.stops.isEmpty {
                    Text("No stops found for this route.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Text("Stops:")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.stops) { stop in
                                NavigationLink(destination: NTUPublicBusStopArrivalView(stop: stop)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(stop.Description)
                                                .font(.headline)
                                            Text(stop.RoadName)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("\(lineName) Stops")
        .onAppear {
            viewModel.loadStops(for: lineName)
        }
    }
}


// Grey background, white list
//import SwiftUI
//
//struct NTUPublicBusLineDetailView: View {
//    let lineName: String
//    @StateObject private var viewModel = NTUPublicBusLineDetailViewModel()
//
//    var body: some View {
//        List {
//            if viewModel.isLoading {
//                ProgressView("Loading stops...")
//            } else if let error = viewModel.errorMessage {
//                Text("Error: \(error)")
//                    .foregroundColor(.red)
//            } else if viewModel.stops.isEmpty {
//                Text("No stops found for this route.")
//                    .foregroundColor(.gray)
//            } else {
//                ForEach(viewModel.stops) { stop in
//                    NavigationLink(destination: NTUPublicBusStopArrivalView(stop: stop)) {
//                        VStack(alignment: .leading) {
//                            Text(stop.Description)
//                                .font(.headline)
//                            Text(stop.RoadName)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                }
//            }
//        }
//        .navigationTitle("\(lineName) Stops")
//        .onAppear {
//            viewModel.loadStops(for: lineName)
//        }
//    }
//}
