//
//  SearchRespository.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation

protocol SearchRespositoryProtocol {
    func getSearchAlbum(query: String, completion: @escaping (Result<[AlbumSearch], Error>) -> Void)
    func getSearchArtist(query: String, completion: @escaping (Result<[ArtistSearch], Error>) -> Void)
    func getSearchTrack(query: String, completion: @escaping (Result<[Track], Error>) -> Void)
}

final class SearchRespository {
    private let apiService: SearchApiServiceProtocol
    
    init(
        apiService: SearchApiServiceProtocol = SearchApiService()
    ) {
        self.apiService = apiService
    }    
}

extension SearchRespository: SearchRespositoryProtocol {
    func getSearchAlbum(query: String, completion: @escaping (Result<[AlbumSearch], Error>) -> Void) {
        apiService.searchAlbum(query: query, completion: { apiResponse in
            switch apiResponse.result {
            case .success(let dto):
                completion(.success(dto.compactMap {$0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        )
    }
    
    func getSearchArtist(query: String, completion: @escaping (Result<[ArtistSearch], Error>) -> Void) {
        apiService.searchArtist(query: query, completion: { apiResponse in
            switch apiResponse.result {
            case .success(let dto):
                completion(.success(dto.compactMap {$0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        )
    }
    
    func getSearchTrack(query: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        apiService.searchTrack(query: query, completion: { apiResponse in
            switch apiResponse.result {
            case .success(let dto):
                completion(.success(dto.compactMap {$0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        )
    }
}
