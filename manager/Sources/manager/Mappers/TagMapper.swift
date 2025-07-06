import api
import Foundation
import models

public enum TagMapper {
    public static func map(_ dto: TagDto?) -> Tag? {
        guard
            let dto,
            let id = dto.id,
            let value = dto.value
        else {
            return nil
        }

        return Tag(id: id, value: value)
    }

    public static func map(_ dtos: [TagDto]?) -> [Tag] {
        guard let dtos else {
            return []
        }
        return dtos.compactMap { map($0) }
    }
} 