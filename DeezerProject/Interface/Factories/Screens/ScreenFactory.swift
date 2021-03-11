//
//  ScreenFactory.swift
//  DeezerProject
//
//  Created by Steven Curtis on 26/02/2021.
//

import UIKit

struct ScreenFactory {}

extension ScreenFactory: BrowseFlowScreenFactoryProtocol {
    func makeGenreScreen(flow: BrowseFlowProtocol, genre: Genre) -> UIViewController {
        let viewModel = GenreViewModel(flow: flow, genre: genre)
        let viewController = GenreViewController(viewModel: viewModel)
        return viewController
    }

    func makeGenreListScreen(flow: BrowseFlowProtocol, data: [BrowseSectionData]) -> UIViewController {
        let viewModel = GenreListViewModel(flow: flow, data: data)
        let viewController = GenreListViewController(viewModel: viewModel)
        return viewController
    }

    func makeBrowseScreen(flow: BrowseFlowProtocol) -> UIViewController {
        let viewModel = BrowseViewModel(flow: flow)
        let viewController = BrowseViewController(viewModel: viewModel)
        return viewController
    }
}

extension ScreenFactory: SearchFlowScreenFactoryProtocol {
    func makeSearchScreen(flow: SearchFlowProtocol) -> UIViewController {
        let viewModel = SearchViewModel(flow: flow)
        let viewController = SearchViewController(viewModel: viewModel)
        return viewController
    }

    func makeAlbumScreen(flow: SearchFlowProtocol, album: AlbumSearch) -> UIViewController {
        let viewModel = AlbumViewModel(flow: flow, album: album)
        let viewController = AlbumViewController(viewModel: viewModel)
        return viewController
    }
}

extension ScreenFactory: ArtistFlowScreenFactoryProtocol {
    func makeArtistScreen(flow: ArtistFlowProtocol, artist: ArtistSearch) -> UIViewController {
        let viewModel = ArtistViewModel(flow: flow, artist: artist)
        let viewController = ArtistViewController(viewModel: viewModel)
        return viewController
    }
}

extension ScreenFactory: TrackFlowScreenFactoryProtocol {
    func makeTrackScreen(flow: TrackFlowProtocol, track: Track, image: String?) -> UIViewController {
        let viewModel = TrackViewModel(flow: flow, track: track, image: image)
        let viewController = TrackViewController(viewModel: viewModel)
        return viewController
    }
}
