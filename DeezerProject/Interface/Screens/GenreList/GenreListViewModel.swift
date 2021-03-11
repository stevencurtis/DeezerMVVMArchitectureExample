//
//  GenreViewModel.swift
//  DeezerProject
//
//  Created by Steven Curtis on 03/03/2021.
//

import Foundation

protocol GenreListViewModelProtocol {
    var genreData: [BrowseSectionData] { get }
    func showGenre(genre: Genre)
}

class GenreListViewModel: GenreListViewModelProtocol {
    public enum Section: CaseIterable, Hashable {
        case grid
    }
    let flow: BrowseFlowProtocol
    let genreData: [BrowseSectionData]
    init(
        flow: BrowseFlowProtocol,
        data: [BrowseSectionData]
    ) {
        self.flow = flow
        self.genreData = data
    }

    func showGenre(genre: Genre) {
        flow.showGenre(genre: genre)
    }
}
