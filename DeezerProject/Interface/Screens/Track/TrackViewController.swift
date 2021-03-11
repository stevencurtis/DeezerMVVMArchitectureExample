//
//  TrackViewController.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import UIKit
import SDWebImage

class TrackViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupComponents()
        setupConstraints()
    }

    let viewModel: TrackViewModelProtocol
    init(viewModel: TrackViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy private var stackView = UIStackView()
    lazy private var controlsStackView = UIStackView()
    lazy private var artistImageView = UIImageView()
    lazy private var artistLabel = UILabel()
    lazy private var trackLabel = UILabel()
    lazy private var playButton = UIButton()
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground
        self.view = view
    }

    func setupHierarchy() {
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(artistImageView)
        stackView.addArrangedSubview(trackLabel)
        stackView.addArrangedSubview(artistLabel)
        stackView.addArrangedSubview(controlsStackView)
        controlsStackView.addArrangedSubview(playButton)

        let logoutBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: viewModel.isFavourite() ? "heart.fill" : "heart",
                withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal
                ),
            style: .plain,
            target: self,
            action: #selector(updateFavourite)
        )
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }

    @objc func updateFavourite() {
        if viewModel.isFavourite() {
            viewModel.deleteFavourite(completion: {
                let logoutBarButtonItem = UIBarButtonItem(
                    image: UIImage(
                        systemName: self.viewModel.isFavourite() ? "heart.fill" : "heart",
                        withConfiguration: self.largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal
                        ),
                    style: .plain,
                    target: self,
                    action: #selector(self.updateFavourite)
                )
                self.navigationItem.rightBarButtonItem = logoutBarButtonItem
            })
        } else {
            viewModel.addFavourite(completion: {
                let logoutBarButtonItem = UIBarButtonItem(
                    image: UIImage(
                        systemName: self.viewModel.isFavourite() ? "heart.fill" : "heart",
                        withConfiguration: self.largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal
                        ),
                    style: .plain,
                    target: self,
                    action: #selector(self.updateFavourite)
                )
                self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
            })
        }
    }

    func setupComponents() {
        stackView.axis = .vertical
        stackView.distribution = .fill

        controlsStackView.axis = .horizontal

        artistLabel.text = viewModel.track.artist?.name
        artistLabel.textAlignment = .left
        artistLabel.font = UIFont.systemFont(ofSize: 16)
        artistLabel.adjustsFontForContentSizeCategory = true

        trackLabel.font = UIFont.boldSystemFont(ofSize: 16)
        trackLabel.adjustsFontForContentSizeCategory = true
        trackLabel.text = viewModel.track.title
        trackLabel.textAlignment = .left

        if viewModel.isPlaying() {
            playButton.setImage(
                UIImage(
                    systemName: "pause.fill",
                    withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal
                    ),
                for: .normal
            )
        } else {
            playButton.setImage(
                UIImage(
                    systemName: "play.fill",
                    withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal
                    ),
                for: .normal
            )
        }

        playButton.addTarget(self, action: #selector(tapped(_:)), for: .touchDown)
        playButton.addTarget(self, action: #selector(tappedUp(_:)), for: .touchUpInside)

        if let picture = viewModel.image ?? viewModel.track.artist!.pictureMedium, let url = URL(string: picture) {
            artistImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "placeholder"),
                options: .highPriority
            )
        }

        artistImageView.contentMode = .scaleAspectFit
        playButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            viewModel.revealMiniPlayer()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.hideMiniPlayer()
    }

    @objc func tappedUp(_ sender: AnyObject) {
        if viewModel.isPlaying() {
            viewModel.pauseSong()
            playButton.setImage(
                UIImage(
                    systemName: "play.fill",
                    withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal),
                for: .normal
            )
        } else {
            viewModel.playSong(track: viewModel.track.preview)
            playButton.setImage(
                UIImage(
                    systemName: "pause.fill",
                    withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal),
                for: .normal
            )
        }
    }

    @objc func tapped(_ sender: AnyObject) {
        if viewModel.isPlaying() {
            playButton.setImage(
                UIImage(
                    systemName: "play.circle",
                    withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal),
                for: .normal)
        } else {
            playButton.setImage(
                UIImage(
                    systemName: "pause.circle",
                    withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal),
                for: .normal)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
