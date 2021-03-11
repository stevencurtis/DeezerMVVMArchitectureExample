//
//  ArtistFlowScreenFactoryProtocol.swift
//  DeezerProject
//
//  Created by Steven Curtis on 10/03/2021.
//

import UIKit

public protocol ArtistFlowScreenFactoryProtocol {
    func makeArtistScreen(flow: ArtistFlowProtocol, artist: ArtistSearch) -> UIViewController
}
