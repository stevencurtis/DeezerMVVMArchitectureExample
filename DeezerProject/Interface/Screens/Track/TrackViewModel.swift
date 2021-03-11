//
//  TrackViewModel.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation

protocol TrackViewModelProtocol {
    var track: Track {get}
    func playSong(track: String)
    func pauseSong()
    func isPlaying() -> Bool
    var image: String? {get}
    func revealMiniPlayer()
    func hideMiniPlayer()
    func isFavourite() -> Bool
    func deleteFavourite(completion: (() -> Void)?)
    func addFavourite(completion: (() -> Void)?)
}

class TrackViewModel: TrackViewModelProtocol {
    let browseInteractor: BrowseInteractorProtocol
    let track: Track
    let image: String?
    let flow: TrackFlowProtocol

    init (
        flow: TrackFlowProtocol,
        browseInteractor: BrowseInteractorProtocol = BrowseInteractor(),
        track: Track,
        image: String?
    ) {
        self.browseInteractor = browseInteractor
        self.track = track
        self.image = image
        self.flow = flow
    }

    func deleteFavourite(completion: (() -> Void)?) {
        browseInteractor.deleteTrack(track: track, completion: completion)
    }

    func addFavourite(completion: (() -> Void)?) {
        if let image = image {
            let imageTrack = track.addArtistImage(image: image)
            browseInteractor.saveTrack(track: imageTrack, completion: completion)
        } else {
            browseInteractor.saveTrack(track: track, completion: completion)
        }
    }

    func isFavourite() -> Bool {
        return browseInteractor.getTracks().first { $0.id == track.id } != nil
    }

    func revealMiniPlayer() {
        if TrackPlayer.shared.playing {
            flow.showMusicBar()
        }
    }

    func hideMiniPlayer() {
        flow.hideMusicBar()
    }

    func pauseSong() {
        TrackPlayer.shared.pause()
    }

    func playSong(track: String) {
        if let url = URL(string: track) {
            TrackPlayer.shared.play(url: url)
        }
    }

    func isPlaying() -> Bool {
        TrackPlayer.shared.playing
    }
}
