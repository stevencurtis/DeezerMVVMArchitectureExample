//
//  SearchViewController.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import UIKit

class SearchViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var dataSource: UICollectionViewDiffableDataSource<SearchViewModel.Section, SearchSectionData>!
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchViewModel.Section, SearchSectionData>

    lazy var layoutSections: [SearchLayoutSectionProtocol] = []

    lazy var layout: UICollectionViewLayout = myCollectionViewLayout
    lazy var collectionView: UICollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    lazy var emptyImage = UIImageView()

    var viewModel: SearchViewModelProtocol

    lazy var myCollectionViewLayout: UICollectionViewLayout = {
         let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
              return self.layoutSections[sectionIndex].layoutSection
         }
         return layout
    }()

    func getLayoutForSection(for section: SearchViewModel.Section) -> SearchLayoutSectionProtocol {
        switch section {
        case .albums:
            return SearchSection(
                title: "Albums",
                onTap: { num in
                    switch self.viewModel.albums[num] {
                    case .albums(let album):
                        self.viewModel.showAlbums(with: album)
                    default: break
                    }
                },
                onFavouriteTap: nil
            )
        case .artist:
            return SearchSection(
                title: "Artists",
                onTap: { num in
                    switch self.viewModel.artists[num] {
                    case .artist(let artist):
                        self.viewModel.showArtist(with: artist)
                    default: break
                    }
                },
                onFavouriteTap: nil
            )
        case .tracks:
            return SearchSection(
                title: "Tracks",
                onTap: { num in
                    switch self.viewModel.tracks[num] {
                    case .tracks(let track):
                        self.viewModel.showTracks(with: track)
                    default: break
                    }
                },
                onFavouriteTap: nil
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()

        title = "Search"
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

        layoutSections.append(getLayoutForSection(for: .albums))
        layoutSections.append(getLayoutForSection(for: .artist))
        layoutSections.append(getLayoutForSection(for: .tracks))

        viewModel.reloadCollectionView = {
              self.applySnapshot()
        }
    }

    func applySnapshot() {
        var currentSnapshot = dataSource.snapshot()

        if viewModel.albums.isEmpty {
            if currentSnapshot.indexOfSection(.albums) != nil {
                currentSnapshot.deleteSections([.albums])
            }
        } else {
            if currentSnapshot.indexOfSection(.albums) == nil {
                currentSnapshot.appendSections([.albums])
            }
            currentSnapshot.appendItems(viewModel.albums, toSection: .albums)
        }

        if viewModel.artists.isEmpty {
            if currentSnapshot.indexOfSection(.artist) != nil {
                currentSnapshot.deleteSections([.artist])
            }
        } else {
            if currentSnapshot.indexOfSection(.artist) == nil {
                currentSnapshot.appendSections([.artist])
            }
            currentSnapshot.appendItems(viewModel.artists, toSection: .artist)
        }

        if viewModel.tracks.isEmpty {
            if currentSnapshot.indexOfSection(.tracks) != nil {
                currentSnapshot.deleteSections([.tracks])
            }
        } else {
            if currentSnapshot.indexOfSection(.tracks) == nil {
                currentSnapshot.appendSections([.tracks])
            }
            currentSnapshot.appendItems(viewModel.tracks, toSection: .tracks)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground
        self.view = view
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         configureHeader()
    }

    func setupSearchController() {
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.placeholder = "Search for an album, song or artist"

        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.delegate = self
        searchController.searchBar.keyboardType = .default

        let placeholderAppearance = UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        placeholderAppearance.font = .systemFont(ofSize: 16)

        navigationController?.navigationBar.barTintColor = UIColor(named: "PrimaryColor")
        navigationItem.searchController = searchController

        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func setupHierarchy() {
        view.addSubview(collectionView)
    }

    func setupComponents() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func deleteAllItems() {
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.deleteItems(viewModel.albums)
        currentSnapshot.deleteItems(viewModel.artists)
        currentSnapshot.deleteItems(viewModel.tracks)
        dataSource.apply(currentSnapshot)
    }

    func deleteAllSection() {
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.deleteSections([.albums, .artist, .tracks])
        dataSource.apply(currentSnapshot)
    }
}

extension SearchViewController {
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
                   buttonTitle: nil,
                action: {}
              )
         }
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <SearchViewModel.Section, SearchSectionData>(
            collectionView: collectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, sectionData: SearchSectionData)
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deleteAllItems()
        self.viewModel.makeSearch(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        deleteAllItems()
        deleteAllSection()
    }
}
