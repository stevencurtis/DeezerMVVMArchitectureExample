//
//  TrackPlayer.swift
//  DeezerProject
//
//  Created by Steven Curtis on 04/03/2021.
//

import Foundation
import AVFoundation

protocol TrackPlayerProtocol {
    static var shared: TrackPlayerProtocol {get}
    func play(url: URL)
    func pause()
    var playing: Bool { get }
    func playCurrent()
}

class TrackPlayer: TrackPlayerProtocol {
    static let shared: TrackPlayerProtocol = TrackPlayer()

    private init() { }

    var playing = false
    var avPlayer: AVPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false

    func play(url: URL) {
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer.playImmediately(atRate: 1)
        playing = true
    }

    func playCurrent() {
        avPlayer.play()
    }

    func pause() {
        avPlayer.pause()
        playing = false
    }
}
