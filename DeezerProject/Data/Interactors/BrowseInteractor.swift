//
//  BrowseInteractor.swift
//  DeezerProject
//
//  Created by Steven Curtis on 01/03/2021.
//

import Foundation

protocol BrowseInteractorProtocol {
    func getGenre(completion: @escaping (Result<[Genre], Error>) -> Void)
    func getChart(completion: @escaping (Result<Chart, Error>) -> Void)
    func getGenreAndGetChart(completion: @escaping (Result<([Genre], Chart?), Error>) -> Void)
    func getGenreArtists(identifier: String, completion: @escaping (Result<[ArtistSearch], Error>) -> Void)
    func getTracklist(identifier: String, completion: @escaping (Result<[Track], Error>) -> Void)
    func saveTrack(track: Track, completion: (() -> Void)?)
    func deleteTrack(track: Track, completion: (() -> Void)?)
    func getTracks() -> [Track]
    func getAlbumTracks(urlString: String, completion: @escaping (Result<[Track], Error>) -> Void)
}

final class BrowseInteractor {
    private let browseRepository: BrowseRepositoryProtocol
    init (
        browseRepository: BrowseRepositoryProtocol = BrowseRepository()
    ) {
        self.browseRepository = browseRepository
    }
}

extension BrowseInteractor: BrowseInteractorProtocol {
    func getAlbumTracks(urlString: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        browseRepository.getAlbumTracklist(urlString: urlString, completion: completion)
    }

    func getTracks() -> [Track] {
        return browseRepository.getTracks()
    }

    func saveTrack(track: Track, completion: (() -> Void)?) {
        browseRepository.createOrUpdate(favourite: track, completion: completion)
    }

    func deleteTrack(track: Track, completion: (() -> Void)?) {
        browseRepository.deleteTrack(track: track, completion: completion)
    }

    func getTracklist(identifier: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        browseRepository.getTracklist(identifier: identifier, completion: completion)
    }

    func getGenreArtists(identifier: String, completion: @escaping (Result<[ArtistSearch], Error>) -> Void) {
        browseRepository.getGenreArtists(identifier: identifier, completion: completion)
    }

    func getGenreAndGetChart(completion: @escaping (Result<([Genre], Chart?), Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var genre: Result<[Genre], Error>?
        var chart: Result<Chart, Error>?
        dispatchGroup.enter()
        getGenre(completion: {genre = $0; dispatchGroup.leave() })
        dispatchGroup.enter()
        getChart(completion: {chart = $0; dispatchGroup.leave() })

        dispatchGroup.notify(queue: .main) {
            switch(genre, chart) {
            case let (.success(genre), .success(chart)):
                completion(.success((genre, chart)))
            case let (.failure, .success(chart)):
                completion(.success(([], chart)))
            case let (.success(genre), .failure):
                completion(.success((genre, nil)))
            default:
                completion(.failure(ApiError.generic))
            }
        }
    }

    func getGenre(completion: @escaping (Result<[Genre], Error>) -> Void) {
        browseRepository.getGenre(completion: completion)
    }

    func getChart(completion: @escaping (Result<Chart, Error>) -> Void) {
        browseRepository.getChart(completion: completion)
    }
}
