import api
import Foundation
import models

public enum EventsMapper {
    public static func map(_ dto: EventDto?) -> Event? {
        guard
            let dto,
            let id = dto.id,
            let title = dto.title
        else {
            return nil
        }

        let location = LocationMapper.map(dto.location)
        guard let location else {
            return nil
        }

        return Event(
            id: id,
            title: title,
            tags: TagMapper.map(dto.tags),
            talks: TalkMapper.map(dto.talks),
            location: location,
            images: dto.images ?? [],
            communities: CommunityMapper.map(dto.communities)
        )
    }

    public static func map(_ dtos: [EventDto]?) -> [Event] {
        guard let dtos else {
            return []
        }
        return dtos.compactMap { map($0) }
    }

    public static func map(_ dto: EventsDto?) -> EventsResponse? {
        guard let dto else {
            return nil
        }

        let events = map(dto.data)
        return EventsResponse(data: events)
    }
} 