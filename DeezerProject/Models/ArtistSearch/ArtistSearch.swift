//
//  ArtistSearch.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation

struct ArtistSearchApiDto: Decodable {
    let id: Int
    let name: String
    let link: String?
    let picture: String
    let pictureSmall: String
    let pictureMedium: String
    let pictureBig: String
    let pictureXl: String
    let nbAlbum: Int?
    let nbFan: Int?
    let radio: Bool
    let tracklist: String
    let type: String
    func toDomain() -> ArtistSearch {
        .init(
            id: id,
            name: name,
            link: link,
            picture: picture,
            pictureSmall: pictureSmall,
            pictureMedium: pictureMedium,
            pictureBig: pictureBig,
            pictureXl: pictureXl,
            nbAlbum: nbAlbum,
            nbFan: nbFan,
            radio: radio,
            tracklist: tracklist,
            type: type
        )
    }
}

public struct ArtistSearch: Hashable {
    let id: Int
    let name: String
    let link: String?
    let picture: String
    let pictureSmall: String
    let pictureMedium: String
    let pictureBig: String
    let pictureXl: String
    let nbAlbum: Int?
    let nbFan: Int?
    let radio: Bool?
    let tracklist: String
    let type: String
}
