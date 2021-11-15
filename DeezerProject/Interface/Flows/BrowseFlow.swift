//
//  BrowseFlow.swift
//  DeezerProject
//
//  Created by Steven Curtis on 01/03/2021.
//

import Foundation
import UIKit
public protocol BrowseFlowProtocol {
    func runFlow()
    func showGenreListScreen(data: [BrowseSectionData])
    func showTrackScreen(track: Track, image: String?)
    func showGenre(genre: Genre)
    func showArtistScreen(artist: ArtistSearch)

}

extension BrowseFlowProtocol {
    func showTrackScreen(track: Track, image: String? = nil) {
        showTrackScreen(track: track, image: nil)
    }
}

final class BrowseFlow {
    private let router: FlowRoutingServiceProtocol
    private let screenFactory: BrowseFlowScreenFactoryProtocol
    private let flowRunner: FlowRunnerProtocol

    init(
        router: FlowRoutingServiceProtocol,
        screenFactory: BrowseFlowScreenFactoryProtocol = ScreenFactory(),
        flowRunner: FlowRunnerProtocol = FlowRunner()
    ) {
        self.router = router
        self.screenFactory = screenFactory
        self.flowRunner = flowRunner
    }
}

extension BrowseFlow: BrowseFlowProtocol {
    func showArtistScreen(artist: ArtistSearch) {
        flowRunner.runArtistFlow(router: router, artist: artist)
    }
    
    func showTrackScreen(track: Track, image: String? = nil) {
        flowRunner.runTrackFlow(router: router, track: track, image: image)
    }

    func runFlow() {
        showBrowseScreen()
    }

    func showBrowseScreen() {
        router.showPushed(
            screenFactory.makeBrowseScreen(flow: self)
        )
    }

    func showGenreListScreen(data: [BrowseSectionData]) {
        router.showPushed(
            screenFactory.makeGenreListScreen(flow: self, data: data)
        )
    }

    func showGenre(genre: Genre) {
        router.showPushed(
            screenFactory.makeGenreScreen(flow: self, genre: genre)
        )
    }
}
