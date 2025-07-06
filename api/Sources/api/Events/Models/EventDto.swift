import Foundation

struct EventDto: Codable {
    let id: String?
    let title: String?
    let tags: [TagDto]?
    let talks: [TalkDto]?
    let location: LocationDto?
    let images: [String]?
    let communities: [CommunityDto]?
}
