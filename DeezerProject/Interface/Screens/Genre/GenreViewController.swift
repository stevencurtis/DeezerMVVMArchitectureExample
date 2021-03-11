//
//  GenreViewController.swift
//  DeezerProject
//
//  Created by Steven Curtis on 05/03/2021.
//

import UIKit

class GenreViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<GenreViewModel.Section, ArtistSearch>!
    typealias Snapshot = NSDiffableDataSourceSnapshot<GenreViewModel.Section, ArtistSearch>
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.genre.name

        setupHierarchy()
        setupComponents()
        setupConstraints()

        collectionView.register(
            SongCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: SongCollectionViewCell.self)
        )

        viewModel.getArtists()

        configureDataSource()

        var snapshot = Snapshot()
        snapshot.appendSections([.grid])
        snapshot.appendItems(viewModel.artists, toSection: .grid)

        dataSource.apply(snapshot, animatingDifferences: true)

        viewModel.reloadCollectionView = {
              self.applySnapshot()
        }
    }

    func applySnapshot() {
        if !viewModel.artists.isEmpty {
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.appendItems(viewModel.artists, toSection: .grid)
            dataSource.apply(currentSnapshot, animatingDifferences: true)
        }
    }

    var viewModel: GenreViewModelProtocol
    lazy var collectionView: UICollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)

    init(viewModel: GenreViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .red
        self.view = view
    }

    lazy var layout = { () -> UICollectionViewFlowLayout in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: 80, height: 80)
        return flowLayout
    }()

    func setupHierarchy() {
        view.addSubview(collectionView)
    }
    func setupComponents() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)

    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension GenreViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <GenreViewModel.Section, ArtistSearch>(
            collectionView: collectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, sectionData: ArtistSearch)
            -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(
                    describing: SongCollectionViewCell.self
                ),
                for: indexPath
            ) as? SongCollectionViewCell else {
                fatalError("Unable to create new cell")
            }
            cell.configure(
                with: sectionData.name,
                pictureURLString: sectionData.pictureMedium,
                onTap: { [unowned self] in
                    self.viewModel.showArtist(artist: self.viewModel.artists[indexPath.row])
                }
            )
            return cell
        }
    }
}
