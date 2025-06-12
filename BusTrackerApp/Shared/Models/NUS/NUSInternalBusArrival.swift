// model to parse arrival response from API
import Foundation

struct ShuttleServiceResponse: Codable {
    let ShuttleServiceResult: ShuttleServiceResult
}

struct ShuttleServiceResult: Codable {
    let TimeStamp: String
    let name: String
    let caption: String
    let shuttles: [Shuttle]
}

struct Shuttle: Codable, Identifiable {
    let name: String
    let nextArrivalTime: String
    let arrivalTime: String
    let arrivalTime_veh_plate: String
    let _etas: [ETA]
    
    let passengers: String
    let routeid: Int
    let busstopcode: String
    let nextPassengers: String
    let nextArrivalTime_veh_plate: String

    var id: Int { routeid } // Enables use in `List(shuttles)`
}

struct ETA: Codable {
    let plate: String
    let ts: String
    let eta: Int
}
