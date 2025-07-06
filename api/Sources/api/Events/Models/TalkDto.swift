import Foundation

public struct TalkDto: Codable {
    public let id: String?
    public let title: String?

    public init(id: String?, title: String?) {
        self.id = id
        self.title = title
    }
}
