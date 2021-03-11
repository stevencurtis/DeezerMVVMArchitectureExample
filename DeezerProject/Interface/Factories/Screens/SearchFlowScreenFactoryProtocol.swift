//
//  SearchFlowScreenFactoryProtocol.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import UIKit

public protocol SearchFlowScreenFactoryProtocol {
    func makeSearchScreen(flow: SearchFlowProtocol) -> UIViewController
    func makeAlbumScreen(flow: SearchFlowProtocol, album: AlbumSearch) -> UIViewController
}
