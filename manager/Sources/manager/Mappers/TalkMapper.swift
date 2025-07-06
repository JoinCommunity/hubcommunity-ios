import api
import Foundation
import models

public enum TalkMapper {
    public static func map(_ dto: TalkDto?) -> Talk? {
        guard
            let dto,
            let id = dto.id,
            let title = dto.title
        else {
            return nil
        }

        return Talk(id: id, title: title)
    }

    public static func map(_ dtos: [TalkDto]?) -> [Talk] {
        guard let dtos else {
            return []
        }
        return dtos.compactMap { map($0) }
    }
} 