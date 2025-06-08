//
//  View.swift
//  ArriveLah
//
//  Created by Ava on 8/6/25.
//

//Test view allows user to enter bus stop code & view arrival info

import SwiftUI

struct BusArrivalTestView: View {
    @State private var busStopCode: String = ""
    @State private var arrivals: [BusService] = []
    @State private var errorMessage: String?

    let service = ArriveLahService()

    var body: some View {
        VStack {
            TextField("Enter Bus Stop Code", text: $busStopCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Fetch Arrivals") {
                fetchArrivals()
            }

            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            }

            List(arrivals, id: \.no) { service in
                VStack(alignment: .leading) {
                    Text("Bus: \(service.no)")
                    if let next = service.next.duration_ms {
                        Text("Arrives in: \(next / 60000) mins")
                    } else {
                        Text("No timing available")
                    }
                }
            }
        }
        .padding()
    }

    private func fetchArrivals() {
        service.fetchBusArrivals(for: busStopCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.arrivals = response.services
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.arrivals = []
                }
            }
        }
    }
}
