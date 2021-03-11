//
//  AlbumViewModel.swift
//  DeezerProject
//
//  Created by Steven Curtis on 10/03/2021.
//

import Foundation

protocol AlbumViewModelProtocol {
    var album: AlbumSearch { get }
    func getTracklist(urlString: String)
    var tracklist: [Track] { get }
    var reloadCollectionView: (() -> Void)? { get set }
    func showTrack(track: Track)
}

class AlbumViewModel: AlbumViewModelProtocol {
    public enum Section: CaseIterable, Hashable {
        case grid
    }
    var reloadCollectionView: (() -> Void)?

    var tracklist: [Track] = []

    let searchInteractor: SearchInteractorProtocol
    let flow: SearchFlowProtocol
    let album: AlbumSearch
    init (
        flow: SearchFlowProtocol,
        searchInteractor: SearchInteractorProtocol = SearchInteractor(),
        album: AlbumSearch
    ) {
        self.searchInteractor = searchInteractor
        self.flow = flow
        self.album = album
    }

    func getTracklist(urlString: String) {
        searchInteractor.getTracklist(urlString: urlString, completion: { result in
            switch result {
            case .success(let tracks):
                self.tracklist = tracks
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
            case .failure:
                break
            }
        })
    }
    func showTrack(track: Track) {
        flow.showTrackScreen(track: track, image: album.coverMedium)
    }
}
