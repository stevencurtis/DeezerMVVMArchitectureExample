//
//  SearchViewModel.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation

protocol SearchViewModelProtocol {
    func makeSearch(with term: String)
    var reloadCollectionView: (() -> Void)? { get set }
    var albums: [SearchSectionData] { get }
    var artists: [SearchSectionData] { get }
    var tracks: [SearchSectionData] { get }
    func showAlbums(with album: AlbumSearch)
    func showArtist(with artist: ArtistSearch)
    func showTracks(with track: Track)
}

public enum SearchSectionData: Hashable {
    case artist(ArtistSearch)
    case albums(AlbumSearch)
    case tracks(Track)
}

class SearchViewModel: NSObject, SearchViewModelProtocol {
    public enum Section: CaseIterable, Hashable {
        case artist
        case albums
        case tracks
    }

    var reloadCollectionView: (() -> Void)?

    var albums: [SearchSectionData] = []
    var artists: [SearchSectionData] = []
    var tracks: [SearchSectionData] = []

    let searchInteractor: SearchInteractorProtocol
    let flow: SearchFlowProtocol
    init(
        searchInteractor: SearchInteractorProtocol = SearchInteractor(),
        flow: SearchFlowProtocol
    ) {
        self.searchInteractor = searchInteractor
        self.flow = flow
    }

    func showAlbums(with album: AlbumSearch) {
        flow.showAlbum(album: album)
    }

    func showArtist(with artist: ArtistSearch) {
        flow.showArtist(artist: artist)
    }

    func showTracks(with track: Track) {
        flow.showTrackScreen(track: track)
    }

    func makeSearch(with term: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(getSearchResults(with:)), with: term, afterDelay: TimeInterval(1.0))
    }

    @objc private func searchAlbums(term: String) {
        searchInteractor.getSearchAlbum(query: term, completion: {res in
            switch res {
            case .success(let albums):
                self.albums = albums.map { SearchSectionData.albums($0) }
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
            case .failure:
                break
            }
        }
        )
    }

    @objc func getSearchResults(with query: String) {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "+")
        searchInteractor.getSearchResults(query: formattedQuery, completion: {data in
            switch data {
            case .success((let album, let track, let artist)):
                self.albums = album.map { SearchSectionData.albums($0) }
                self.tracks = track.map { SearchSectionData.tracks($0) }
                self.artists = artist.map { SearchSectionData.artist($0) }
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
            case .failure:
                self.albums = []
                self.tracks = []
                self.artists = []
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
            }
        }
        )
    }
}
