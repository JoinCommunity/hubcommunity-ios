import Foundation

public struct CommunityDto: Codable {
    public let id: String?
    public let title: String?
    public let membersQuantity: Int?

    public init(id: String?, title: String?, membersQuantity: Int?) {
        self.id = id
        self.title = title
        self.membersQuantity = membersQuantity
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case membersQuantity = "members_quantity"
    }
}
