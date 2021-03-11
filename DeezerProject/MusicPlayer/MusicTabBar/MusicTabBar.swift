//
//  MusicTabBar.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import UIKit

public class MusicTabBar: UITabBarController, UITabBarControllerDelegate {
    private let mini = MiniPlayer()
    lazy private var playButton = UIButton()
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if TrackPlayer.shared.playing {
            mini.isHidden = false
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        mini.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mini)
        mini.addSubview(playButton)

        playButton.setImage(
            UIImage(
                systemName: "pause.fill",
                withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal
                ),
            for: .normal
        )
        playButton.addTarget(self, action: #selector(tapped(_:)), for: .touchDown)

        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mini.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            mini.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mini.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mini.heightAnchor.constraint(equalToConstant: 50),
            playButton.centerXAnchor.constraint(equalTo: mini.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: mini.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        mini.isHidden = true
    }

    @objc func tapped(_ sender: AnyObject) {
        if TrackPlayer.shared.playing {
            playButton.setImage(
                UIImage(
                    systemName: "play.circle",
                    withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal),
                for: .normal
            )
            toggleMusic()
        } else {
            playButton.setImage(
                UIImage(
                    systemName: "pause.circle",
                    withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal),
                for: .normal
            )
            toggleMusic()
        }
    }

    func toggleMiniPlayer() {
        mini.isHidden = !mini.isHidden
    }

    func toggleMusic() {
        if TrackPlayer.shared.playing {
            TrackPlayer.shared.pause()
        } else {
            TrackPlayer.shared.playCurrent()
        }
    }

    func hideMusicPlayer() {
        mini.isHidden = true
    }

    func showMusicPlayer() {
        mini.isHidden = false
    }

    func isPlaying() -> Bool {
        TrackPlayer.shared.playing
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
