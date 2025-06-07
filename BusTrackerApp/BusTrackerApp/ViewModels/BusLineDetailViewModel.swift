import Foundation

@MainActor
class BusLineDetailViewModel: ObservableObject {
    @Published var bus: Bus? = nil
    @Published var stops: [BusStop] = []
    @Published var isLoadingBus = false
    @Published var isLoadingStops = false
    @Published var errorMessage: String? = nil

    private let apiClient: BusAPIClient

    init(apiClient: BusAPIClient = .shared) {
        self.apiClient = apiClient
    }

    func fetchBus(for line: BusRouteColor) async {
        isLoadingBus = true
        errorMessage = nil
        do {
            let fetchedBus = try await apiClient.fetchBusLineInfo(for: line).bus
            self.bus = fetchedBus
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoadingBus = false
    }

    func fetchStops(for line: BusRouteColor) async {
        isLoadingStops = true
        errorMessage = nil
        do {
            let fetchedStops = try await apiClient.fetchStops(for: line)
            self.stops = fetchedStops
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoadingStops = false
    }
}
