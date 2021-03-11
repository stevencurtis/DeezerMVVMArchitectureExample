//
//  AlbumViewController.swift
//  DeezerProject
//
//  Created by Steven Curtis on 10/03/2021.
//

import UIKit

class AlbumViewController: UIViewController {
    var viewModel: AlbumViewModelProtocol
    lazy var artistImageView = UIImageView()
    lazy var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.album.title

        setupHierarchy()
        setupComponents()
        setupConstraints()

        viewModel.reloadCollectionView = {
            self.tableView.reloadData()
        }
    }

    init(viewModel: AlbumViewModelProtocol) {
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getTracklist(urlString: viewModel.album.tracklist)
    }

    func setupHierarchy() {
        self.view.addSubview(artistImageView)
        self.view.addSubview(tableView)
    }

    func setupComponents() {
        if let url = URL(string: viewModel.album.coverMedium) {
            artistImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "placeholder"),
                options: .highPriority
            )
        }
        artistImageView.contentMode = .scaleAspectFit
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            artistImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: artistImageView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showTrack(track: viewModel.tracklist[indexPath.row])
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tracklist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = viewModel.tracklist[indexPath.row].title
            return cell
        }
        fatalError("Unable to dequeue cell")
    }

}
