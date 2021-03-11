//
//  GridSection.swift
//  DeezerProject
//
//  Created by Steven Curtis on 03/03/2021.
//

import UIKit

struct GridSection: BrowseLayoutSectionProtocol {
    let onTap: ((Int) -> Void)?
    let onFavouriteTap: ((Int) -> Void)?

    func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: BrowseSectionData,
        position: Int
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(
                describing: SongCollectionViewCell.self
            ),
            for: indexPath
        ) as? SongCollectionViewCell else {
            fatalError("Unable to create new cell")
        }
        switch item {
        case .chart(let chart):
            cell.configure(
                with: chart.title,
                pictureURLString: chart.artist?.pictureMedium,
                onTap: {
                    onTap?(indexPath.row)
                }
            )
        case .genre(let genre):
            cell.configure(
                with: genre.name,
                pictureURLString: genre.pictureMedium,
                onTap: {
                    onTap?(indexPath.row)
                }
            )
        case .favourite:
            break
        }
        return cell
    }

    var layoutSection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.92),
            heightDimension: .fractionalWidth(0.33)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)

        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }()

}
