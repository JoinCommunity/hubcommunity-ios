import Foundation

public struct CommunitiesDto: Codable {
    public let data: [CommunityDto]?

    public init(data: [CommunityDto]?) {
        self.data = data
    }
}
