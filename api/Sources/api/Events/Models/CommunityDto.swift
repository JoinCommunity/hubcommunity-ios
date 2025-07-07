import Foundation

public struct CommunityDto: Codable {
    public let id: String?
    public let title: String?
    public let images: [String]?
    public let membersQuantity: Int?
    public let shortDescription: String?
    public let tags: [TagDto]?

    public init(
        id: String?,
        title: String?,
        images: [String]?,
        membersQuantity: Int?,
        shortDescription: String?,
        tags: [TagDto]?
    ) {
        self.id = id
        self.title = title
        self.images = images
        self.membersQuantity = membersQuantity
        self.shortDescription = shortDescription
        self.tags = tags
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case images
        case membersQuantity = "members_quantity"
        case shortDescription = "short_description"
        case tags
    }
}
