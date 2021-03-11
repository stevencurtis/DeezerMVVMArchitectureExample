//
//  AlbumSearch.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation

struct AlbumSearchApiDto: Decodable {
    let id: Int
    let title: String
    let cover: String
    let coverSmall: String
    let coverMedium: String
    let coverBig: String
    let coverXl: String
    let md5Image: String
    let genreId: Int
    let nbTracks: Int
    let recordType: String
    let tracklist: String
    let explicitLyrics: Bool
    let artist: AlbumSearchApiDto.Artist
    func toDomain() -> AlbumSearch {
        .init(
            id: id,
            title: title,
            cover: cover,
            coverSmall: coverSmall,
            coverMedium: coverMedium,
            coverBig: coverBig,
            coverX1: coverXl,
            md5Image: md5Image,
            genreId: genreId,
            nbTracks: nbTracks,
            recordType: recordType,
            tracklist: tracklist,
            explicitLyrics: explicitLyrics,
            artist: artist.toDomain()
        )
    }

    struct Artist: Decodable {
        let id: Int
        let name: String
        let link: String
        let picture: String
        let pictureSmall: String
        let pictureMedium: String
        let pictureBig: String
        let pictureXl: String
        func toDomain() -> AlbumSearch.Artist {
            .init(
                id: id,
                name: name,
                link: link,
                picture: picture,
                pictureSmall: pictureSmall,
                pictureMedium: pictureMedium,
                pictureBig: pictureBig,
                pictureXl: pictureXl
            )
        }
    }
}

public struct AlbumSearch: Hashable {
    let id: Int
    let title: String
    let cover: String
    let coverSmall: String
    let coverMedium: String
    let coverBig: String
    let coverX1: String
    let md5Image: String
    let genreId: Int
    let nbTracks: Int
    let recordType: String
    let tracklist: String
    let explicitLyrics: Bool
    let artist: AlbumSearch.Artist

    struct Artist: Hashable {
        let id: Int
        let name: String
        let link: String
        let picture: String
        let pictureSmall: String
        let pictureMedium: String
        let pictureBig: String
        let pictureXl: String
    }
}
