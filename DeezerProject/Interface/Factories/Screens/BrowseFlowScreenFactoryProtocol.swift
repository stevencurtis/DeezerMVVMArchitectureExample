//
//  BrowseFlowScreenFactory.swift
//  DeezerProject
//
//  Created by Steven Curtis on 01/03/2021.
//

import UIKit

public protocol BrowseFlowScreenFactoryProtocol {
    func makeBrowseScreen(flow: BrowseFlowProtocol) -> UIViewController
    func makeGenreListScreen(flow: BrowseFlowProtocol, data: [BrowseSectionData]) -> UIViewController
    func makeGenreScreen(flow: BrowseFlowProtocol, genre: Genre) -> UIViewController
}
