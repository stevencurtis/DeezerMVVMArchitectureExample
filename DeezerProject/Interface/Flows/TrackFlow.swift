//
//  TrackFlow.swift
//  DeezerProject
//
//  Created by Steven Curtis on 10/03/2021.
//

import UIKit

public protocol TrackFlowProtocol {
    func runFlow(with track: Track, image: String?)
    func showMusicBar()
    func hideMusicBar()
}

final class TrackFlow {
    private let router: FlowRoutingServiceProtocol
    private let screenFactory: TrackFlowScreenFactoryProtocol

    init(
        router: FlowRoutingServiceProtocol,
        screenFactory: TrackFlowScreenFactoryProtocol = ScreenFactory()
    ) {
        self.router = router
        self.screenFactory = screenFactory
    }
}

extension TrackFlow: TrackFlowProtocol {
    func runFlow(with track: Track, image: String?) {
        showTrackScreen(track: track, image: image)
    }

    private func showTrackScreen(track: Track, image: String?) {
        router.showPushed(
            screenFactory.makeTrackScreen(flow: self, track: track, image: image)
        )
    }

    func showMusicBar() {
        router.showMusicBar()
    }

    func hideMusicBar() {
        router.hideMusicBar()
    }
}
