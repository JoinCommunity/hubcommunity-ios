import Foundation

public struct CommunitiesResponse: Codable, Sendable {
    public let communities: [Community]

    public init(communities: [Community]) {
        self.communities = communities
    }
}
