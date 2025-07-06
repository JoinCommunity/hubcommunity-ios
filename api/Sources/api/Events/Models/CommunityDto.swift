import Foundation

struct CommunityDto: Codable {
    let id: String?
    let title: String?
    let membersQuantity: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case membersQuantity = "members_quantity"
    }
}
