//
//  GenreViewController.swift
//  DeezerProject
//
//  Created by Steven Curtis on 03/03/2021.
//

import UIKit

class GenreListViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<GenreListViewModel.Section, BrowseSectionData>!
    typealias Snapshot = NSDiffableDataSourceSnapshot<GenreListViewModel.Section, BrowseSectionData>

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground
        self.view = view
    }

    lazy var layout = { () -> UICollectionViewFlowLayout in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = .init(width: 80, height: 80)
        return flowLayout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupComponents()
        setupConstraints()

        collectionView.register(
            SongCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: SongCollectionViewCell.self)
        )

        configureDataSource()

        var snapshot = Snapshot()
        snapshot.appendSections([.grid])
        snapshot.appendItems(viewModel.genreData, toSection: .grid)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

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

    var viewModel: GenreListViewModelProtocol
    lazy var collectionView: UICollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)

    lazy var layoutSections: [BrowseLayoutSectionProtocol] = []

    init(viewModel: GenreListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GenreListViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <GenreListViewModel.Section, BrowseSectionData>(
            collectionView: collectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, sectionData: BrowseSectionData)
            -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(
                    describing: SongCollectionViewCell.self
                ),
                for: indexPath
            ) as? SongCollectionViewCell else {
                fatalError("Unable to create new cell")
            }

            switch sectionData {
            case .chart:
                break
            case .genre(let genre):
                cell.configure(
                    with: genre.name,
                    pictureURLString: genre.pictureMedium,
                    onTap: {
                        print("onTap \(indexPath.row)")
                        let genre = self.viewModel.genreData[indexPath.row]
                        switch genre {
                        case .genre(let genre):
                            self.viewModel.showGenre(genre: genre)
                        default: break
                        }
                    }
                )
            case .favourite:
                break
            }
            return cell

        }
    }
}
