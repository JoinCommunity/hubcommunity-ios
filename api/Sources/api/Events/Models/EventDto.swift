import Foundation

public struct EventDto: Codable {
    public let id: String?
    public let title: String?
    public let tags: [TagDto]?
    public let talks: [TalkDto]?
    public let location: LocationDto?
    public let images: [String]?
    public let communities: [CommunityDto]?

    public init(
        id: String?,
        title: String?,
        tags: [TagDto]?,
        talks: [TalkDto]?,
        location: LocationDto?,
        images: [String]?,
        communities: [CommunityDto]?
    ) {
        self.id = id
        self.title = title
        self.tags = tags
        self.talks = talks
        self.location = location
        self.images = images
        self.communities = communities
    }
}
