//
//  SearchFlow.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation

public protocol SearchFlowProtocol {
    func runFlow()
    func showAlbum(album: AlbumSearch)
    func showArtist(artist: ArtistSearch)
    func showTrackScreen(track: Track, image: String?)
}

extension SearchFlowProtocol {
    func showTrackScreen(track: Track) {
        showTrackScreen(track: track, image: nil)
    }
}

final class SearchFlow {
    private let router: FlowRoutingServiceProtocol
    private let screenFactory: SearchFlowScreenFactoryProtocol
    private let flowRunner: FlowRunnerProtocol

    init(
        router: FlowRoutingServiceProtocol,
        screenFactory: SearchFlowScreenFactoryProtocol = ScreenFactory(),
        flowRunner: FlowRunnerProtocol = FlowRunner()
    ) {
        self.router = router
        self.screenFactory = screenFactory
        self.flowRunner = flowRunner
    }
}

extension SearchFlow: SearchFlowProtocol {
    func showTrackScreen(track: Track, image: String? = nil) {
        flowRunner.runTrackFlow(router: router, track: track, image: image)
    }

    func showArtist(artist: ArtistSearch) {
        flowRunner.runArtistFlow(router: router, artist: artist)
    }

    func runFlow() {
        showSearchScreen()
    }

    private func showSearchScreen() {
        router.showPushed(
            screenFactory.makeSearchScreen(flow: self)
        )
    }

    func showAlbum(album: AlbumSearch) {
        router.showPushed(screenFactory.makeAlbumScreen(flow: self, album: album))
    }
}
