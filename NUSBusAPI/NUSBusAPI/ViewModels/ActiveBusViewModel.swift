//
//  ActiveBusViewModel.swift
//  NUSBusAPI
//
//  Created by Ava on 12/6/25.
//

import Foundation

class ActiveBusViewModel: ObservableObject {
    @Published var activeBuses: [ActiveBus] = []
    @Published var error: String?
    
    func fetchActiveBuses(for routeCode: String) {
        NUSNextBusService.shared.fetchActiveBuses(routeCode: routeCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.activeBuses = response.activebus
                    self.error = nil
                case .failure(let error):
                    // Custom handling for "Service not found!" as a plain string
                    if let urlError = error as? URLError {
                        self.error = "Network error: \(urlError.localizedDescription)"
                    } else if let decodingError = error as? DecodingError {
                        self.error = "Decoding error: \(decodingError.localizedDescription)"
                    } else {
                        self.error = error.localizedDescription
                    }
                }
            }
        }
    }

}
