//
//  LayoutSection.swift
//  CompositionalLayouts
//
//  Created by Steven Curtis on 26/06/2020.
//  Copyright © 2020 Steven Curtis. All rights reserved.
//

import UIKit

protocol LayoutSection {
    var title: String { get set }
    var layoutSection: NSCollectionLayoutSection {get}
    func configureCell(collectionView: UICollectionView,
                       indexPath: IndexPath,
                       item: AnyHashable,
                       position: Int
    ) -> UICollectionViewCell
    func header(collectionView: UICollectionView,
                indexPath: IndexPath,
                title: String,
                buttonTitle: String?,
                action: @escaping (Int) -> Void
    ) -> UICollectionReusableView
}
