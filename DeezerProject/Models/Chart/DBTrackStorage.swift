//
//  DBTrack.swift
//  DeezerProject
//
//  Created by Steven Curtis on 08/03/2021.
//

import Foundation
import CoreData

@objcMembers
final class DBTrackStorage: NSManagedObject {
    static var entityName: String {
        return "Track"
    }

    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var titleShort: String
    @NSManaged var link: String
    @NSManaged var duration: NSNumber
    @NSManaged var rank: NSNumber
    @NSManaged var explicitLyrics: Bool
    @NSManaged var explicitContentCover: NSNumber
    @NSManaged var preview: String
    @NSManaged var md5Image: String
    @NSManaged var pictureMedium: String
}

extension DBTrackStorage {
    func update(from dto: TrackApiDto) {
        id = NSNumber(value: dto.id)
        title = dto.title
        titleShort = dto.titleShort
        link = dto.link ?? ""
        duration = NSNumber(value: dto.duration)
        rank = NSNumber(value: dto.rank)
        pictureMedium = dto.artist?.pictureMedium ?? ""
    }

    func toDto() -> TrackApiDto {
        return TrackApiDto.init(
            id: id.intValue,
            title: title,
            titleShort: titleShort,
            titleVersion: nil,
            link: link,
            duration: duration.intValue,
            rank: rank.intValue,
            explicitLyrics: explicitLyrics,
            explicitContentLyrics: nil,
            explicitContentCover: 0,
            preview: preview,
            md5Image: md5Image,
            position: nil,
            artist: .init(
                id: id.intValue,
                name: "",
                link: nil,
                picture: nil,
                pictureSmall: nil,
                pictureMedium: pictureMedium,
                pictureBig: nil,
                pictureXl: nil,
                radio: nil
            )
        )
    }
}
