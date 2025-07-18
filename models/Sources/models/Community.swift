import Foundation

public struct Community: Codable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let membersQuantity: Int

    public init(id: String, title: String, membersQuantity: Int) {
        self.id = id
        self.title = title
        self.membersQuantity = membersQuantity
    }
}
