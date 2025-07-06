import Foundation

public struct EventsDto: Codable {
    public let data: [EventDto]?

    public init(data: [EventDto]?) {
        self.data = data
    }
}
