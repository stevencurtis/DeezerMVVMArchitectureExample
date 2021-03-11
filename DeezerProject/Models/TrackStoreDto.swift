//
//  TrackStoreDto.swift
//  DeezerProject
//
//  Created by Steven Curtis on 10/03/2021.
//

import Foundation

struct TrackStoreDto: Equatable {
    let id: Int
    let title: String
    let titleShort: String
    let titleVersion: String?
    let link: String?
    let duration: Int
    let rank: Int
    let explicitLyrics: Bool
    let explicitContentLyrics: Int?
    let explicitContentCover: Int
    let preview: String
    let md5Image: String
    let position: Int?

    func toDomain() -> Track {
        return .init(
            id: id,
            title: title,
            titleShort: titleShort,
            titleVersion: titleVersion,
            link: link,
            duration: duration,
            rank: rank,
            explicitLyrics: explicitLyrics,
            explicitContentLyrics: explicitContentLyrics,
            explicitContentCover: explicitContentCover,
            preview: preview,
            md5Image: md5Image,
            position: position,
            artist: nil
        )
    }
}

extension TrackStoreDto {
    init?(favourite: TrackApiDto) {
        self.id = favourite.id
        self.title = favourite.title
        self.titleShort = favourite.titleShort
        self.titleVersion = favourite.titleVersion
        self.link = favourite.link
        self.duration = favourite.duration
        self.rank = favourite.rank
        self.explicitLyrics = favourite.explicitLyrics
        self.explicitContentCover = favourite.explicitContentCover
        self.explicitContentLyrics = favourite.explicitContentLyrics
        self.preview = favourite.preview
        self.md5Image = favourite.md5Image
        self.position = favourite.position
    }
}
