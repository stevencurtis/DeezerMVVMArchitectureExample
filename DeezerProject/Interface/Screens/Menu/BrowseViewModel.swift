//
//  MenuViewModel.swift
//  DeezerProject
//
//  Created by Steven Curtis on 26/02/2021.
//

import Foundation

protocol BrowseViewModelProtocol {
    func getGenreAndChart()
    var genre: [BrowseSectionData] { get set }
    var chart: [BrowseSectionData]? { get set }
    var favourites: [BrowseSectionData] { get set }
    var reloadCollectionView: (() -> Void)? { get set }
    func moveGenre()
    func moveTrack(with track: Track)
    func showGenre(with genre: Genre)
    func addFavourites(with data: BrowseSectionData)
    func updateFavourites()
    func deleteFavourite(track: Track, completion: (() -> Void)?)
}

public enum BrowseSectionData: Hashable {
    case chart(Track)
    case genre(Genre)
    case favourite(Track)
}

class BrowseViewModel: BrowseViewModelProtocol {
    func addFavourites(with data: BrowseSectionData) {
        switch data {
        case .chart(let track):
            browseInteractor.saveTrack(track: track, completion: {
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
            })
        default: break
        }
    }

    var chart: [BrowseSectionData]? = []
    var genre: [BrowseSectionData] = []
    var favourites: [BrowseSectionData] = []

    public enum Section: CaseIterable, Hashable {
        case genre
        case chart
        case favourites
    }

    var reloadCollectionView: (() -> Void)?

    let browseInteractor: BrowseInteractorProtocol
    let flow: BrowseFlowProtocol
    init (
        browseInteractor: BrowseInteractorProtocol = BrowseInteractor(),
        flow: BrowseFlowProtocol
    ) {
        self.browseInteractor = browseInteractor
        self.flow = flow
    }

    func moveGenre() {
        flow.showGenreListScreen(data: genre)
    }

    func showGenre(with genre: Genre) {
        flow.showGenre(genre: genre)
    }

    func moveTrack(with track: Track) {
        flow.showTrackScreen(track: track)
    }

    func updateFavourites() {
        self.favourites = self.browseInteractor.getTracks().map { BrowseSectionData.favourite($0) }
    }

    func getSavedTracks() -> [Track] {
        return browseInteractor.getTracks()
    }

    func deleteFavourite(track: Track, completion: (() -> Void)?) {
        browseInteractor.deleteTrack(track: track, completion: completion)
    }

    func getGenreAndChart() {
        browseInteractor.getGenreAndGetChart(completion: { data in
            switch data {
            case .success((let genre, let chart)):
                self.genre = genre.map { BrowseSectionData.genre($0) }
                self.chart = chart?.tracks.data.map { BrowseSectionData.chart($0) }
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
            case .failure:
                self.genre = []
                self.chart = nil
                DispatchQueue.main.async {
                    self.reloadCollectionView?()
                }
            }
        })
    }
}
