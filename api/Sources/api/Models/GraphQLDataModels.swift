import Foundation

// MARK: - GraphQL Data Models

struct TagData: Codable {
    let id: String?
    let value: String?
}

struct TalkData: Codable {
    let id: String?
    let title: String?
}

struct LocationData: Codable {
    let id: String?
    let title: String?
}

struct CommunityData: Codable {
    let id: String?
    let title: String?
    let membersQuantity: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case membersQuantity = "members_quantity"
    }
}
