//
//  FavouritesSection.swift
//  FavouriteProjectsSection
//
//  Created by Steven Curtis on 22/02/2021.
//

import UIKit

struct BrowseSection: BrowseLayoutSectionProtocol, HeaderSectionProtocol {
    var title: String
    var buttonTitle: String?
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
        case .favourite(let favourite):
            cell.configure(
                with: favourite.title,
                pictureURLString: favourite.artist?.pictureMedium,
                onTap: {
                    onTap?(indexPath.row)
                },
                topRightAction: ButtonModel.init(
                    action: {
                        onFavouriteTap?(indexPath.row)
                    },
                    icon: "heart.fill"
                )
            )
        }
        return cell
    }

    var layoutSection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalWidth(0.33)
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

    func header(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        title: String,
        buttonTitle: String?,
        action: @escaping () -> Void
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: TitleSupplementaryView.self),
            for: indexPath
        )
        if let hdr = header as? TitleSupplementaryView {
            hdr.configure(with:
                            .init(
                                title: title.description
                                ,
                                button: ButtonModel(
                                    title: buttonTitle,
                                    action: {action()}
                                )
                            )
            )
        }
        return header
    }
}
