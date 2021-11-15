//
//  GenreViewModel.swift
//  DeezerProject
//
//  Created by Steven Curtis on 05/03/2021.
//

import Foundation

protocol GenreViewModelProtocol {
    var genre: Genre { get }
    var artists: [ArtistSearch] { get }
    func getArtists()
    var reloadCollectionView: (() -> Void)? { get set }
    func showArtist(artist: ArtistSearch)
}

class GenreViewModel: GenreViewModelProtocol {
    public enum Section: CaseIterable, Hashable {
        case grid
    }
    let browseInteractor: BrowseInteractorProtocol
    let flow: BrowseFlowProtocol
    let genre: Genre
    var artists: [ArtistSearch] = []
    var reloadCollectionView: (() -> Void)?

    init (
        browseInteractor: BrowseInteractorProtocol = BrowseInteractor(),
        flow: BrowseFlowProtocol,
        genre: Genre
    ) {
        self.browseInteractor = browseInteractor
        self.flow = flow
        self.genre = genre
    }

    func getArtists() {
        browseInteractor.getGenreArtists(identifier: genre.id.description, completion: { result in
            switch result {
            case .success(let artists):
                self.artists = artists
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
            case .failure:
                break
            }
        })
    }

    func showArtist(artist: ArtistSearch) {
        flow.showArtistScreen(artist: artist)
    }
}
