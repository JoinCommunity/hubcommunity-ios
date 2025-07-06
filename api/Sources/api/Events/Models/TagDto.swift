import Foundation

public struct TagDto: Codable {
    public let id: String?
    public let value: String?

    public init(id: String?, value: String?) {
        self.id = id
        self.value = value
    }
}
