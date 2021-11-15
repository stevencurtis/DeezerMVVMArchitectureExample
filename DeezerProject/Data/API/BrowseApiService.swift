//
//  BrowseApiService.swift
//  DeezerProject
//
//  Created by Steven Curtis on 01/03/2021.
//

import Foundation
import NetworkLibrary

protocol BrowseApiServiceProtocol {
    func getGenre(completion: @escaping (ApiResponse<[GenreApiDto]>) -> Void)
    func getChart(completion: @escaping (ApiResponse<ChartApiDto>) -> Void)
    func getGenreArtists(identifier: String, completion: @escaping (ApiResponse<[ArtistSearchApiDto]>) -> Void)
    func getTracklist(identifier: String, completion: @escaping (ApiResponse<[TrackApiDto]>) -> Void)
    func getAlbumList(urlString: String, completion: @escaping (ApiResponse<[TrackApiDto]>) -> Void)
}

final class BrowseApiService {
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

extension BrowseApiService: BrowseApiServiceProtocol {
    func getGenre(completion: @escaping (ApiResponse<[GenreApiDto]>) -> Void) {
        guard let url = URL(string: "https://api.deezer.com/genre") else {return}
        anyNetworkManager?.fetch(
            url: url,
            method: .get(),
            completionBlock: {result in
                if let res = try? result.get() {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let decoded = try? decoder.decode(WrappedData<[GenreApiDto]>.self, from: res) {
                        completion(.success(.init(), decoded.data))
                        return
                    }
                }
                completion(.failure(nil, ApiError.network(errorMessage: "Decode error")))
            }
        )
    }

    func getChart(completion: @escaping (ApiResponse<ChartApiDto>) -> Void) {
        guard let url = URL(string: "https://api.deezer.com/chart") else {return}
        anyNetworkManager?.fetch(
            url: url,
            method: .get(),
            completionBlock: {result in
                if let res = try? result.get() {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let decoded = try? decoder.decode(ChartApiDto.self, from: res) {
                        completion(.success(.init(), decoded))
                        return
                    }
                }
                completion(.failure(nil, ApiError.network(errorMessage: "Decode error")))
            }
        )
    }

    func getGenreArtists(identifier: String, completion: @escaping (ApiResponse<[ArtistSearchApiDto]>) -> Void) {
        guard let url = URL(string: "https://api.deezer.com/genre/\(identifier)/artists") else {return}
        anyNetworkManager?.fetch(
            url: url,
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

    func getTracklist(identifier: String, completion: @escaping (ApiResponse<[TrackApiDto]>) -> Void) {
        guard let url = URL(string: "https://api.deezer.com/artist/\(identifier)/top?limit=50") else {return}
        anyNetworkManager?.fetch(
            url: url,
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

    func getAlbumList(urlString: String, completion: @escaping (ApiResponse<[TrackApiDto]>) -> Void) {
        guard let url = URL(string: urlString) else {return}
        anyNetworkManager?.fetch(
            url: url,
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
