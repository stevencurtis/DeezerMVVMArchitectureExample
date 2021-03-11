//
//  BrowseRepository.swift
//  DeezerProject
//
//  Created by Steven Curtis on 01/03/2021.
//

import Foundation
import NetworkLibrary

protocol BrowseRepositoryProtocol {
    func getGenre(completion: @escaping (Result<[Genre], Error>) -> Void)
    func getChart(completion: @escaping (Result<Chart, Error>) -> Void)
    func getGenreArtists(identifier: String, completion: @escaping (Result<[ArtistSearch], Error>) -> Void)
    func getTracklist(identifier: String, completion: @escaping (Result<[Track], Error>) -> Void)
    func createOrUpdate(favourite: Track, completion: (() -> Void)?)
    func getTracks() -> [Track]
    func deleteTrack(track: Track, completion: (() -> Void)?)
    func getAlbumTracklist(urlString: String, completion: @escaping (Result<[Track], Error>) -> Void)
}

final class BrowseRepository {
    private let apiService: BrowseApiServiceProtocol
    private let storageService: FavouritesStorageServiceProtocol

    init(
        apiService: BrowseApiServiceProtocol = BrowseApiService(),
        storageService: FavouritesStorageServiceProtocol = FavouritesStorageService()
    ) {
        self.apiService = apiService
        self.storageService = storageService
    }
}

extension BrowseRepository: BrowseRepositoryProtocol {
    func deleteTrack(track: Track, completion: (() -> Void)?) {
        storageService.delete(track: updateApiDtoFavouriteFrom(favourite: track), completion: completion)
    }

    func getTracks() -> [Track] {
        return storageService.getFavourites().map { $0.toDomain() }
    }

    private func updateApiDtoFavouriteFrom(favourite: Track) -> TrackApiDto {
        guard let artistID = favourite.artist?.id, let artistName = favourite.artist?.name else {
            return .init(
                id: favourite.id,
                title: favourite.title,
                titleShort: favourite.titleShort,
                titleVersion: favourite.titleVersion,
                link: favourite.link,
                duration: favourite.duration,
                rank: favourite.rank,
                explicitLyrics: favourite.explicitLyrics,
                explicitContentLyrics: favourite.explicitContentLyrics,
                explicitContentCover: favourite.explicitContentCover,
                preview: favourite.preview,
                md5Image: favourite.md5Image,
                position: favourite.position,
                artist: nil
            )
        }
        return .init(
            id: favourite.id,
            title: favourite.title,
            titleShort: favourite.titleShort,
            titleVersion: favourite.titleVersion,
            link: favourite.link,
            duration: favourite.duration,
            rank: favourite.rank,
            explicitLyrics: favourite.explicitLyrics,
            explicitContentLyrics: favourite.explicitContentLyrics,
            explicitContentCover: favourite.explicitContentCover,
            preview: favourite.preview,
            md5Image: favourite.md5Image,
            position: favourite.position,
            artist: .init(
                id: artistID,
                name: artistName,
                link: favourite.artist?.link,
                picture: favourite.artist?.picture,
                pictureSmall: favourite.artist?.pictureSmall,
                pictureMedium: favourite.artist?.pictureMedium,
                pictureBig: favourite.artist?.pictureBig,
                pictureXl: favourite.artist?.pictureXl,
                radio: favourite.artist?.radio
            )
        )
    }

    // swiftlint:disable:next function_body_length
    func createOrUpdate(favourite: Track, completion: (() -> Void)?) {
        storageService.save(favourite: updateApiDtoFavouriteFrom(favourite: favourite), completion: completion)
    }

    func getGenreArtists(identifier: String, completion: @escaping (Result<[ArtistSearch], Error>) -> Void) {
        apiService.getGenreArtists(identifier: identifier, completion: { apiResponse in
            switch apiResponse.result {
            case .success(let dto):
                completion(.success(dto.compactMap {$0.toDomain()}) )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        )
    }

    func getGenre(completion: @escaping (Result<[Genre], Error>) -> Void) {
        apiService.getGenre(completion: { apiReponse in
            switch apiReponse.result {
            case .success(let dto):
                completion(.success(dto.compactMap {$0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        )
    }

    func getChart(completion: @escaping (Result<Chart, Error>) -> Void) {
        apiService.getChart(completion: {apiResponse in
            switch apiResponse.result {
            case .success(let dto):
                completion(.success(dto.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        )
    }

    func getTracklist(identifier: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        apiService.getTracklist(identifier: identifier, completion: {apiResponse in
            switch apiResponse.result {
            case .success(let dto):
                completion(.success(dto.compactMap {$0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        )
    }

    func getAlbumTracklist(urlString: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        apiService.getAlbumList(urlString: urlString, completion: {apiResponse in
            switch apiResponse.result {
            case .success(let dto):
                completion(.success(dto.compactMap {$0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

}
