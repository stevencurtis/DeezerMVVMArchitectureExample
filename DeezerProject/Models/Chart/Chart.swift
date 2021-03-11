//
//  Chart.swift
//  DeezerProject
//
//  Created by Steven Curtis on 01/03/2021.
//

import Foundation

struct ChartApiDto: Decodable {
    let tracks: TracksApiDto

    struct TracksApiDto: Decodable {
        let data: [TrackApiDto]
        let total: Int
    }
}

public struct TrackApiDto: Decodable {
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
    let artist: ArtistApiDto?
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
            artist: artist?.toDomain()
        )
    }
}

extension ChartApiDto {
    func toDomain() -> Chart {
        return .init(
            tracks: tracks.toDomain()
        )
    }
}

extension ChartApiDto.TracksApiDto {
    func toDomain() -> Tracks {
        return .init(data: data.compactMap {$0.toDomain()}, total: total)
    }
}

struct ArtistApiDto: Decodable {
    let id: Int
    let name: String
    let link: String?
    let picture: String?
    let pictureSmall: String?
    let pictureMedium: String?
    let pictureBig: String?
    let pictureXl: String?
    let radio: Bool?
    func toDomain() -> Artist {
        .init(
            id: id,
            name: name,
            link: link,
            picture: picture,
            pictureSmall: pictureSmall,
            pictureMedium: pictureMedium,
            pictureBig: pictureBig,
            pictureXl: pictureXl,
            radio: radio
        )
    }
}

struct AlbumApiDto: Decodable {
    let id: Int
    let title: String
    let upc: String
    let link: String
    let share: String
    let cover: String
    let coverSmall: String
    let coverMedium: String
    let coverBig: String
    let coverX1: String
    let md5Image: String
    func toDomain() -> Album {
        .init(
            id: id,
            title: title,
            upc: upc,
            link: link,
            share: share,
            cover: cover,
            coverSmall: coverSmall,
            coverMedium: coverMedium,
            coverBig: coverBig,
            coverX1: coverX1,
            md5Image: md5Image
        )
    }
}

public struct Tracks: Hashable {
    let data: [Track]
    let total: Int
}

public struct Track: Hashable {
    public static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }
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
    let artist: Artist?

    func addArtistImage(image: String) -> Track {
        guard let musicArtist = artist else {return self}
        let changedArtist = Artist(
            id: musicArtist.id,
            name: musicArtist.name,
            link: musicArtist.link,
            picture: musicArtist.picture,
            pictureSmall: musicArtist.pictureSmall,
            pictureMedium: image,
            pictureBig: musicArtist.pictureBig,
            pictureXl: musicArtist.pictureXl,
            radio: musicArtist.radio
        )
        return Track(
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
            artist: changedArtist
        )
    }
}

public struct Chart: Hashable {
    let tracks: Tracks
}

struct Artist: Hashable {
    let id: Int
    let name: String
    let link: String?
    let picture: String?
    let pictureSmall: String?
    let pictureMedium: String?
    let pictureBig: String?
    let pictureXl: String?
    let radio: Bool?
}

struct Album: Hashable {
    let id: Int
    let title: String
    let upc: String
    let link: String
    let share: String
    let cover: String
    let coverSmall: String
    let coverMedium: String
    let coverBig: String
    let coverX1: String
    let md5Image: String
}
