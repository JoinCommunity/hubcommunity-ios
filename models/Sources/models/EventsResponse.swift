import Foundation

public struct EventsResponse: Codable, Sendable {
    public let data: [Event]

    public init(data: [Event]) {
        self.data = data
    }
}
