//
//  NUSPublicBusStopListView.swift
//  BusTrackerApp
//
//  Created by Ava Vispilio on 11/6/25.
// Displays a list of NUS's public bus stops for a selected bus route

// white bg, grey list
//import SwiftUI
//
//struct NUSPublicBusStopListView: View {
//    let line: PublicBusLine
//    @StateObject private var viewModel = NUSPublicBusStopListViewModel()
//    
//    @StateObject private var stopViewModelsHolder = ViewModelCache()
//        
//    class ViewModelCache: ObservableObject {
//        @Published var cache: [String: NUSPublicBusArrivalViewModel] = [:]
//    }
//
//    var body: some View { // this view
//        ZStack {
//            Color.white.ignoresSafeArea()
//
//            if viewModel.isLoading {
//                ProgressView("Loading stops...")
//            } else if let error = viewModel.errorMessage {
//                Text("Error: \(error)")
//                    .foregroundColor(.red)
//                    .padding()
//            } else {
//                ScrollView {
//                    LazyVStack(alignment: .leading, spacing: 12) {
//                        ForEach(viewModel.stops) { stop in
//                            NavigationLink(destination: NUSPublicBusArrivalView(viewModel: getOrCreateViewModel(for: stop))) {
//                                HStack {
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text(stop.Description)
//                                            .font(.headline)
//                                        Text(stop.RoadName)
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
//                                    }
//                                    Spacer()
//                                    Image(systemName: "chevron.right")
//                                        .foregroundColor(.gray)
//                                }
//                                .padding()
//                                .background(Color(UIColor.secondarySystemBackground))
//                                .cornerRadius(10)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                    }
//                    .padding()
//                }
//            }
//        }
//        .navigationTitle("Bus \(line.lineName)")
//        .onAppear {
//            viewModel.loadStops(for: line)
//        }
//    }
//    
//    private func getOrCreateViewModel(for stop: PublicBusStop) -> NUSPublicBusArrivalViewModel {
//        let key = "\(stop.BusStopCode)_\(line.lineName)"  // Unique per stop+service
//
//        if let existing = stopViewModelsHolder.cache[key] {
//            return existing
//        } else {
//            let newVM = NUSPublicBusArrivalViewModel(stop: stop, busService: line.lineName)
//            stopViewModelsHolder.cache[key] = newVM
//            return newVM
//        }
//    }
//}

import SwiftUI

struct NUSPublicBusStopListView: View {
    let line: PublicBusLine
    @StateObject private var viewModel = NUSPublicBusStopListViewModel()
    
    @StateObject private var stopViewModelsHolder = ViewModelCache()

    class ViewModelCache: ObservableObject {
        @Published var cache: [String: NUSPublicBusArrivalViewModel] = [:]
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Loading stops...")
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else {
                stopListView
            }
        }
        .navigationTitle("Bus \(line.lineName)")
        .onAppear {
            viewModel.loadStops(for: line)
        }
    }

    private func getOrCreateViewModel(for stop: PublicBusStop) -> NUSPublicBusArrivalViewModel {
        let key = "\(stop.BusStopCode)_\(line.lineName)"
        if let existing = stopViewModelsHolder.cache[key] {
            return existing
        } else {
            let newVM = NUSPublicBusArrivalViewModel(stop: stop, busService: line.lineName)
            stopViewModelsHolder.cache[key] = newVM
            return newVM
        }
    }
}

private extension NUSPublicBusStopListView {
    var stopListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.stops) { stop in
                    stopRow(for: stop)
                }
            }
            .padding()
        }
    }

    func stopRow(for stop: PublicBusStop) -> some View {
        NavigationLink(destination: NUSPublicBusArrivalView(viewModel: getOrCreateViewModel(for: stop))) {
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

    func errorView(_ error: String) -> some View {
        Text("Error: \(error)")
            .foregroundColor(.red)
            .padding()
    }
}
