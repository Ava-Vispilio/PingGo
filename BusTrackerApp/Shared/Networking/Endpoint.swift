import Foundation

enum Endpoint {
    case lineInfo(color: String)      // For example: /prod/blue-bus
    case busStopDetails               // /prod/bus-stop-details
    case busArrival(busStopId: String)  // /prod/bus-arrival?busStopId=[ID]

    private var baseURL: String {
        return "http://10.203.4.23:3000/prod"  // Replace with your server's IP
    }

    var url: URL {
        switch self {
        case .lineInfo(let color):
            return URL(string: "\(baseURL)/\(color)-bus")!
        case .busStopDetails:
            return URL(string: "\(baseURL)/bus-stop-details")!
        case .busArrival(let busStopId):
            return URL(string: "\(baseURL)/bus-arrival?busStopId=\(busStopId)")!
        }
    }
}
