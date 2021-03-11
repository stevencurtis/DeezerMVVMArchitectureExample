//
//  ViewController.swift
//  DeezerProject
//
//  Created by Steven Curtis on 26/02/2021.
//

import UIKit
import NetworkLibrary

class BrowseViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<BrowseViewModel.Section, BrowseSectionData>!
    typealias Snapshot = NSDiffableDataSourceSnapshot<BrowseViewModel.Section, BrowseSectionData>

    lazy var layoutSections: [BrowseLayoutSectionProtocol] = []

    lazy var emptyView = UIView()
    lazy var layout: UICollectionViewLayout = myCollectionViewLayout
    lazy var collectionView: UICollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    lazy var emptyImage = UIImageView()

    var viewModel: BrowseViewModelProtocol

    lazy var myCollectionViewLayout: UICollectionViewLayout = {
         let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
              return self.layoutSections[sectionIndex].layoutSection
         }
         return layout
    }()

    // swiftlint:disable:next cyclomatic_complexity
    func getLayoutForSection(for section: BrowseViewModel.Section) -> BrowseLayoutSectionProtocol {
        switch section {
        case .chart:
            return BrowseSection(
                title: "Chart",
                onTap: { item in
                    switch self.viewModel.chart?[item] {
                    case .chart(let chart):
                        self.viewModel.moveTrack(with: chart)
                    default: break
                    }
                },
                onFavouriteTap: nil
            )
        case .genre:
            return BrowseSection(
                title: "Genre",
                buttonTitle: "See All",
                onTap: { [unowned self] item in
                    switch self.viewModel.genre[item] {
                    case .genre(let genre):
                        viewModel.showGenre(with: genre)
                    default: break
                    }
                },
                onFavouriteTap: nil
            )
        case .favourites:
            return BrowseSection(
                title: "Favourites",
                onTap: { item in
                    switch self.viewModel.chart?[item] {
                    case .chart(let chart):
                        self.viewModel.moveTrack(with: chart)
                    default: break
                    }
                },
                onFavouriteTap: { item in
                    switch self.viewModel.favourites[item] {
                    case .favourite(let favourite):
                        self.viewModel.deleteFavourite(track: favourite, completion: {
                            self.updateFavourites()
                        })
                    default: break
                    }
                }
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Music"

        setupHierarchy()
        setupComponents()
        setupConstraints()

        collectionView.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: TitleSupplementaryView.self)
        )

        collectionView.register(
            SongCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: SongCollectionViewCell.self)
        )

        configureDataSource()

        layoutSections.append(getLayoutForSection(for: .genre))
        layoutSections.append(getLayoutForSection(for: .chart))
        layoutSections.append(getLayoutForSection(for: .favourites))

        var snapshot = Snapshot()
        snapshot.appendSections([.genre])
        snapshot.appendSections([.chart])
        snapshot.appendSections([.favourites])

        dataSource.apply(snapshot, animatingDifferences: true)

        viewModel.reloadCollectionView = {
            self.applySnapshot()
        }

        viewModel.getGenreAndChart()
    }

    func setupHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        emptyView.addSubview(emptyImage)
    }

    func setupComponents() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground

        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.backgroundColor = .systemBackground

        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.image = UIImage(named: "ohdear")
        emptyImage.contentMode = .scaleAspectFit
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyImage.topAnchor.constraint(equalTo: view.topAnchor, constant: +50),
            emptyImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func applySnapshot() {
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.appendItems(viewModel.genre, toSection: .genre)

        if viewModel.genre.isEmpty {
            currentSnapshot.deleteSections([.genre])
        }

        if let chart = viewModel.chart {
            currentSnapshot.appendItems(chart, toSection: .chart)
        } else {
            currentSnapshot.deleteSections([.chart])
        }

        if viewModel.genre.isEmpty && viewModel.chart == nil {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }

    override func loadView() {
        let view = UIView()
        self.view = view
    }

    init(viewModel: BrowseViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureHeader()
        updateFavourites()
    }

    func updateFavourites() {
        viewModel.updateFavourites()

        var currentSnapshot = Snapshot()
        currentSnapshot.appendSections([.genre])
        currentSnapshot.appendSections([.chart])

        if viewModel.favourites.count > 0 {
            if currentSnapshot.indexOfSection(.favourites) == nil {
                currentSnapshot.appendSections([.favourites])
                currentSnapshot.appendItems(self.viewModel.favourites, toSection: .favourites)
            }
        } else {
            if currentSnapshot.indexOfSection(.favourites) != nil {
                currentSnapshot.deleteSections([.favourites])
            }
        }
        if let chartItems = self.viewModel.chart {
            currentSnapshot.appendItems(chartItems, toSection: .chart)
        }
        currentSnapshot.appendItems(self.viewModel.genre, toSection: .genre)

        self.dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

extension BrowseViewController {
    func configureHeader() {
         dataSource.supplementaryViewProvider = {
              (
                   collectionView: UICollectionView,
                   kind: String,
                   indexPath: IndexPath
              )
              -> UICollectionReusableView in
            guard let section = self.layoutSections[indexPath.section] as? HeaderSectionProtocol else {fatalError()}
            return section.header(
                collectionView: collectionView,
                indexPath: indexPath,
                title: section.title,
                buttonTitle: section.buttonTitle,
                action: {
                    switch BrowseViewModel.Section.allCases[indexPath.section] {
                    case .chart:
                        break
                    case .favourites:
                        break
                    case .genre:
                        self.viewModel.moveGenre()
                    }
                }
            )
         }
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <BrowseViewModel.Section, BrowseSectionData>(
            collectionView: collectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, sectionData: BrowseSectionData)
            -> UICollectionViewCell? in
            return self.layoutSections[indexPath.section].configureCell(
                collectionView: collectionView,
                indexPath: indexPath,
                item: sectionData,
                position: indexPath.row
            )
        }
    }
}
