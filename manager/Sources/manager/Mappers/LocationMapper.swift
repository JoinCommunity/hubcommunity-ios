import api
import Foundation
import models

public enum LocationMapper {
    public static func map(_ dto: LocationDto?) -> Location? {
        guard
            let dto,
            let id = dto.id,
            let title = dto.title
        else {
            return nil
        }

        return Location(id: id, title: title)
    }
}
