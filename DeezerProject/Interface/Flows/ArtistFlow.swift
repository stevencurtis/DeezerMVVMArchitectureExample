//
//  ArtistFlow.swift
//  DeezerProject
//
//  Created by Steven Curtis on 10/03/2021.
//

import Foundation

public protocol ArtistFlowProtocol {
    func showArtist(artist: ArtistSearch)
    func runFlow(with artist: ArtistSearch)
    func showTrack(track: Track, image: String)
}

final class ArtistFlow {
    private let router: FlowRoutingServiceProtocol
    private let screenFactory: ArtistFlowScreenFactoryProtocol
    private let flowRunner: FlowRunnerProtocol

    init(
        router: FlowRoutingServiceProtocol,
        screenFactory: ArtistFlowScreenFactoryProtocol = ScreenFactory(),
        flowRunner: FlowRunnerProtocol = FlowRunner()
    ) {
        self.router = router
        self.screenFactory = screenFactory
        self.flowRunner = flowRunner
    }
}

extension ArtistFlow: ArtistFlowProtocol {
    func showTrack(track: Track, image: String) {
        flowRunner.runTrackFlow(router: router, track: track, image: image)
    }

    func showArtist(artist: ArtistSearch) {
        router.showPushed(screenFactory.makeArtistScreen(flow: self, artist: artist))
    }

    func runFlow(with artist: ArtistSearch) {
        showArtistScreen(artist: artist)
    }

    private func showArtistScreen(artist: ArtistSearch) {
        router.showPushed(
            screenFactory.makeArtistScreen(flow: self, artist: artist)
        )
    }
}
