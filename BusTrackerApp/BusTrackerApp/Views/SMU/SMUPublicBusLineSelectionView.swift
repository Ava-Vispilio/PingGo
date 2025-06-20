//
//  SMUPublicBusLineSelectionView.swift
//  BusTrackerApp
//
//  Created by Ava on 16/6/25.
//
// Displays bus services for a selected bus stop
// Just a note that for SMU, bus stop selection view comes before bus line selection view

import SwiftUI

struct SMUPublicBusLineSelectionView: View {
    let stop: PublicBusStop
    @StateObject private var viewModel = SMUPublicBusLineSelectionViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading bus services…")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.services.isEmpty {
                Text("No upcoming buses at this stop.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Bus Stop: \(stop.Description)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    List(viewModel.services, id: \.serviceNo) { service in
                        NavigationLink(destination: SMUPublicBusArrivalView(stop: stop, arrival: service)) {
                            Text("\(service.serviceNo)")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .padding(.top, -8)
                }
            }
        }
        .navigationTitle("Operating Bus Lines")
        .onAppear {
            Task {
                await viewModel.fetchServices(for: stop.BusStopCode)
            }
        }
    }
}

//import SwiftUI
//
//struct SMUPublicBusLineSelectionView: View {
//    let stop: PublicBusStop
//    @StateObject private var viewModel = SMUPublicBusLineSelectionViewModel()
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(stop.Description)
//                .font(.title2)
//                .padding(.top)
//
//            if viewModel.isLoading {
//                ProgressView("Loading bus services…")
//                    .padding()
//            } else if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .padding()
//            } else if viewModel.services.isEmpty {
//                Text("No upcoming buses at this stop.")
//                    .foregroundColor(.gray)
//                    .padding()
//            } else {
//                List(viewModel.services, id: \.serviceNo) { service in
//                    NavigationLink(destination: SMUPublicBusArrivalView(stop: stop, arrival: service)) {
//                        Text("Bus \(service.serviceNo)")
//                    }
//                }
//                .listStyle(.insetGrouped)
//            }
//
//            Spacer()
//        }
//        .padding(.horizontal)
//        .navigationTitle("Bus Services")
//        .onAppear {
//            Task {
//                await viewModel.fetchServices(for: stop.BusStopCode)
//            }
//        }
//    }
//}
//
//

//import SwiftUI
//
//struct SMUPublicBusLineSelectionView: View {
//    let stop: PublicBusStop
//    @StateObject private var viewModel = SMUPublicBusArrivalViewModel()
//
//    @State private var expandedServices: Set<String> = []
//    @State private var notifyServices: [String: Bool] = [:]
//    @State private var notifyMinutesBefore: [String: Int] = [:]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(stop.Description)
//                .font(.title2)
//                .padding(.top)
//
//            if !viewModel.publicActiveLines.isEmpty {
//                Section(header: Text("NTU Public Buses")) {
//                    ForEach(viewModel.publicActiveLines, id: \.self) { lineName in
//                                NavigationLink(destination: NTUPublicBusLineDetailView(lineName: lineName)) {
//                                    Text(lineName.capitalized)
//                                }
//                            }
//                }
//            } else if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .padding(.horizontal)
//        .onAppear {
//            Task {
//                await viewModel.fetchArrivals(for: stop.BusStopCode)
//            }
//        }
//    }
//}
