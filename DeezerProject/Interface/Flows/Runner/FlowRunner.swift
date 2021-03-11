//
//  FlowRunner.swift
//  DeezerProject
//
//  Created by Steven Curtis on 10/03/2021.
//

import Foundation

public protocol FlowRunnerProtocol {
    func runBrowseFlow(
        router: FlowRoutingServiceProtocol
    )

    func runSearchFlow(
        router: FlowRoutingServiceProtocol
    )

    func runArtistFlow(
        router: FlowRoutingServiceProtocol,
        artist: ArtistSearch
    )

    func runTrackFlow(
        router: FlowRoutingServiceProtocol,
        track: Track,
        image: String?
    )
}

public struct FlowRunner {
    public init() {}
}

extension FlowRunner: FlowRunnerProtocol {
    public func runTrackFlow(
        router: FlowRoutingServiceProtocol,
        track: Track,
        image: String?
    ) {
        TrackFlow(router: router).runFlow(with: track, image: image)
    }

    public func runBrowseFlow(
        router: FlowRoutingServiceProtocol
    ) {
        BrowseFlow(
            router: router
        ).runFlow()
    }

    public func runSearchFlow(
        router: FlowRoutingServiceProtocol
    ) {
        SearchFlow(
            router: router
        ).runFlow()
    }

    public func runArtistFlow(
        router: FlowRoutingServiceProtocol,
        artist: ArtistSearch
    ) {
        ArtistFlow(
            router: router
        ).runFlow(with: artist)
    }

}
