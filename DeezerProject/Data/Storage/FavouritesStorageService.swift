//
//  FavouritesStorage.swift
//  DeezerProject
//
//  Created by Steven Curtis on 05/03/2021.
//

import Foundation

protocol FavouritesStorageServiceProtocol {
    func save(favourite: TrackApiDto, completion: (() -> Void)?)
    func getFavourites() -> [TrackApiDto]
    func delete(track: TrackApiDto, completion: (() -> Void)?)
}

final class FavouritesStorageService {
    private let dataManager: DataManager

    init(dataManager: DataManager = DataManager()) {
        self.dataManager = dataManager
    }
}
extension FavouritesStorageService: FavouritesStorageServiceProtocol {
    func getFavourites() -> [TrackApiDto] {
        let favourites = try? dataManager.getFavourites()
        return favourites ?? []
    }

    func save(favourite: TrackApiDto, completion: (() -> Void)?) {
        dataManager.save(favourite: favourite, completion: completion)
    }

    func delete(track: TrackApiDto, completion: (() -> Void)?) {
        try? dataManager.delete(favourite: track, completion: completion)
    }
}
