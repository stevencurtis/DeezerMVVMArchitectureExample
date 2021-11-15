//
//  SearchInteractor.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation

protocol SearchInteractorProtocol {
    func getSearchAlbum(query: String, completion: @escaping (Result<[AlbumSearch], Error>) -> Void)
    func getSearchTrack(query: String, completion: @escaping (Result<[Track], Error>) -> Void)
    func getSearchArtist(query: String, completion: @escaping (Result<[ArtistSearch], Error>) -> Void)
    func getSearchResults(query: String, completion: @escaping (Result<([AlbumSearch], [Track], [ArtistSearch]), Error>) -> Void)
    func getTracklist(urlString: String, completion: @escaping (Result<[Track], Error>) -> Void)
}

class SearchInteractor {
    private let searchRepository: SearchRespositoryProtocol
    private let browseRepository: BrowseRepositoryProtocol

    init(
        searchRepository: SearchRespositoryProtocol = SearchRespository(),
        browseRepository: BrowseRepositoryProtocol = BrowseRepository()
    ) {
        self.searchRepository = searchRepository
        self.browseRepository = browseRepository
    }
}

extension SearchInteractor: SearchInteractorProtocol {
    func getTracklist(urlString: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        browseRepository.getAlbumTracklist(urlString: urlString, completion: completion)
    }

    func getSearchResults(
        query: String,
        // swiftlint:disable large_tuple
        completion: @escaping (Result<([AlbumSearch], [Track], [ArtistSearch]), Error>) -> Void
    ) {
        let dispatchGroup = DispatchGroup()

        var album: Result<[AlbumSearch], Error>?
        var track: Result<[Track], Error>?
        var artist: Result<[ArtistSearch], Error>?

        dispatchGroup.enter()
        getSearchAlbum(query: query, completion: { album = $0; dispatchGroup.leave() })
        dispatchGroup.enter()
        getSearchTrack(query: query, completion: { track = $0; dispatchGroup.leave() })
        dispatchGroup.enter()
        getSearchArtist(query: query, completion: { artist = $0; dispatchGroup.leave() })

        dispatchGroup.notify(queue: .main) {
            switch(album, track, artist) {
            case let (.success(album), .success(track), .success(artist)):
                completion(.success((album, track, artist)))
            case let (.failure, .success(track), .success(artist)):
                completion(.success(([], track, artist)))
            case let (.success(album), .failure, .success(artist)):
                completion(.success((album, [], artist)))
            case let (.success(album), .success(track), .failure):
                completion(.success((album, track, [])))
            case let (.success(album), .failure, .failure):
                completion(.success((album, [], [])))
            case let (.failure, .success(track), .failure):
                completion(.success(([], track, [])))
            case let (.failure, .failure, .success(artist)):
                completion(.success(([], [], artist)))
            default:
                completion(.failure(ApiError.generic))
            }
        }
    }

    func getSearchAlbum(query: String, completion: @escaping (Result<[AlbumSearch], Error>) -> Void) {
        searchRepository.getSearchAlbum(query: query, completion: completion)
    }

    func getSearchTrack(query: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        searchRepository.getSearchTrack(query: query, completion: completion)
    }

    func getSearchArtist(query: String, completion: @escaping (Result<[ArtistSearch], Error>) -> Void) {
        searchRepository.getSearchArtist(query: query, completion: completion)
    }
}
