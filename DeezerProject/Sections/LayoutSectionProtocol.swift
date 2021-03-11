//
//  LayoutSection.swift
//  CompositionalLayouts
//
//  Created by Steven Curtis on 26/06/2020.
//  Copyright © 2020 Steven Curtis. All rights reserved.
//

import UIKit

protocol HeaderSectionProtocol {
    var title: String { get set }
    var buttonTitle: String? { get set }
    func header(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        title: String,
        buttonTitle: String?,
        action: @escaping () -> Void
    ) -> UICollectionReusableView
}

protocol BrowseLayoutSectionProtocol {
    var layoutSection: NSCollectionLayoutSection {get}
    func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: BrowseSectionData,
        position: Int
    ) -> UICollectionViewCell
}

protocol SearchLayoutSectionProtocol {
    var layoutSection: NSCollectionLayoutSection {get}
    func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: SearchSectionData,
        position: Int
    ) -> UICollectionViewCell
}
