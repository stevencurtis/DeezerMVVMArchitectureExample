//
//  Genre.swift
//  DeezerProject
//
//  Created by Steven Curtis on 01/03/2021.
//

import Foundation

struct GenreApiDto: Decodable {
    let id: Int
    let name: String
    let picture: String
    let pictureSmall: String
    let pictureMedium: String
    let pictureBig: String
    let pictureXl: String
    let type: String
}

extension GenreApiDto {
    func toDomain() -> Genre? {
        return .init(
            id: id,
            name: name,
            picture: picture,
            pictureSmall: pictureSmall,
            pictureMedium: pictureMedium,
            pictureBig: pictureBig,
            pictureXl: pictureXl,
            type: type
        )
    }
}

public struct Genre: Hashable {
    let id: Int
    let name: String
    let picture: String
    let pictureSmall: String
    let pictureMedium: String
    let pictureBig: String
    let pictureXl: String
    let type: String

    public init(
        id: Int,
        name: String,
        picture: String,
        pictureSmall: String,
        pictureMedium: String,
        pictureBig: String,
        pictureXl: String,
        type: String
    ) {
        self.id = id
        self.name = name
        self.picture = picture
        self.pictureSmall = pictureSmall
        self.pictureMedium = pictureMedium
        self.pictureBig = pictureBig
        self.pictureXl = pictureXl
        self.type = type
    }
}
