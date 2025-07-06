import api
import Foundation
import models

public enum CommunityMapper {
    public static func map(_ dto: CommunityDto?) -> Community? {
        guard
            let dto,
            let id = dto.id,
            let title = dto.title,
            let membersQuantity = dto.membersQuantity
        else {
            return nil
        }

        return Community(id: id, title: title, membersQuantity: membersQuantity)
    }

    public static func map(_ dtos: [CommunityDto]?) -> [Community] {
        guard let dtos else {
            return []
        }
        return dtos.compactMap { map($0) }
    }
} 