//
//  NTUPublicBusLineDetailView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
//
// Displays a list of NTU's public bus stops (to choose from) for a selected bus route

import SwiftUI

// White background, full page scrollable
struct NTUPublicBusLineDetailView: View {
    let lineName: String
    @StateObject private var viewModel = NTUPublicBusLineDetailViewModel()
    
    @StateObject private var stopViewModelsHolder = ViewModelCache()
    
    class ViewModelCache: ObservableObject {
        @Published var cache: [String: NTUPublicBusStopArrivalViewModel] = [:]
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // White background

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView("Loading stops...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
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

                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.stops) { stop in
                                NavigationLink(destination: NTUPublicBusStopArrivalView(viewModel: getOrCreateViewModel(for: stop))) {
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
                .padding(.top)
            }
        }
        .navigationTitle("Bus \(lineName)")
        .onAppear {
            viewModel.loadStops(for: lineName)
        }
    }
    private func getOrCreateViewModel(for stop: PublicBusStop) -> NTUPublicBusStopArrivalViewModel {
        if let existing = stopViewModelsHolder.cache[stop.BusStopCode] {
            return existing
        } else {
            let newVM = NTUPublicBusStopArrivalViewModel(stop: stop)
            stopViewModelsHolder.cache[stop.BusStopCode] = newVM
            return newVM
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
