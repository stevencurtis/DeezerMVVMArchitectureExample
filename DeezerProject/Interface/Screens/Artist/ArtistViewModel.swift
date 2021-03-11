//
//  ArtistViewModel.swift
//  DeezerProject
//
//  Created by Steven Curtis on 05/03/2021.
//

import Foundation

protocol ArtistViewModelProtocol {
    var artist: ArtistSearch { get }
    func getTracklist(identifier: String)
    var reloadCollectionView: (() -> Void)? { get set }
    var tracklist: [Track] { get }
    func showTrack(track: Track)
}

class ArtistViewModel: ArtistViewModelProtocol {
    var reloadCollectionView: (() -> Void)?

    let artist: ArtistSearch
    let browseInteractor: BrowseInteractorProtocol
    let flow: ArtistFlowProtocol
    var tracklist: [Track] = []
    init (
        browseInteractor: BrowseInteractorProtocol = BrowseInteractor(),
        flow: ArtistFlowProtocol,
        artist: ArtistSearch
    ) {
        self.browseInteractor = browseInteractor
        self.flow = flow
        self.artist = artist
    }

    func showTrack(track: Track) {
        flow.showTrack(track: track, image: artist.pictureMedium)
    }

    func getTracklist(identifier: String) {
        browseInteractor.getTracklist(identifier: identifier, completion: { result in
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
}
