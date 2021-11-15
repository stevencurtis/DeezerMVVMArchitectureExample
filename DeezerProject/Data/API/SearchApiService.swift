//
//  SearchApiService.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation
import NetworkLibrary

protocol SearchApiServiceProtocol {
    func searchAlbum(query: String, completion: @escaping (ApiResponse<[AlbumSearchApiDto]>) -> Void)
    func searchArtist(query: String, completion: @escaping (ApiResponse<[ArtistSearchApiDto]>) -> Void)
    func searchTrack(query: String, completion: @escaping (ApiResponse<[TrackApiDto]>) -> Void)
}

final class SearchApiService {
    private var anyNetworkManager: AnyNetworkManager<URLSession>?

    init() {
        self.anyNetworkManager = AnyNetworkManager()
    }

    init<T: NetworkManagerProtocol>(
        networkManager: T
    ) {
        self.anyNetworkManager = AnyNetworkManager(manager: networkManager)
    }
}

extension SearchApiService: SearchApiServiceProtocol {
    func searchAlbum(query: String, completion: @escaping (ApiResponse<[AlbumSearchApiDto]>) -> Void) {
        anyNetworkManager?.fetch(
            url: URL(string: "https://api.deezer.com/search/album?q=\(query)")!,
            method: .get(),
            completionBlock: {result in
                if let res = try? result.get() {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let decoded = try? decoder.decode(WrappedData<[AlbumSearchApiDto]>.self, from: res) {
                        completion(.success(.init(), decoded.data))
                        return
                    }
                }
                completion(.failure(nil, ApiError.network(errorMessage: "Decode error")))
            }
        )
    }
    func searchArtist(query: String, completion: @escaping (ApiResponse<[ArtistSearchApiDto]>) -> Void) {
        anyNetworkManager?.fetch(
            url: URL(string: "https://api.deezer.com/search/artist?q=\(query)")!,
            method: .get(),
            completionBlock: {result in
                if let res = try? result.get() {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let decoded = try? decoder.decode(WrappedData<[ArtistSearchApiDto]>.self, from: res) {
                        completion(.success(.init(), decoded.data))
                        return
                    }
                }
                completion(.failure(nil, ApiError.network(errorMessage: "Decode error")))
            }
        )
    }
    func searchTrack(query: String, completion: @escaping (ApiResponse<[TrackApiDto]>) -> Void) {
        anyNetworkManager?.fetch(
            url: URL(string: "https://api.deezer.com/search/track?q=\(query)")!,
            method: .get(),
            completionBlock: {result in
                if let res = try? result.get() {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let decoded = try? decoder.decode(WrappedData<[TrackApiDto]>.self, from: res) {
                        completion(.success(.init(), decoded.data))
                        return
                    }
                }
                completion(.failure(nil, ApiError.network(errorMessage: "Decode error")))
            }
        )
    }
}
