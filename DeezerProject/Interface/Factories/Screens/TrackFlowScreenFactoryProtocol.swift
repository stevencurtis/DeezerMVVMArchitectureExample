//
//  TrackFlowScreenFactoryProtocol.swift
//  DeezerProject
//
//  Created by Steven Curtis on 10/03/2021.
//

import UIKit

public protocol TrackFlowScreenFactoryProtocol {
    func makeTrackScreen(flow: TrackFlowProtocol, track: Track, image: String?) -> UIViewController
}
