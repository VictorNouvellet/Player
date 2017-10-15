//
//  PlayerManager.swift
//  Player
//
//  Created by Victor Nouvellet on 10/14/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerManager: NSObject {
    
    // PlayerManager ingleton
    static let shared = PlayerManager()
    
    // Audio player property
    var player: AVAudioPlayer? = nil
    var songEnded: Bool = false
    
    // Playing song property
    var song: SongModel? = nil {
        didSet {
            guard let songUrlString = song?.iTunesPreviewUrl, let songUrl = URL(string: songUrlString) else {
                song = nil
                songEnded = true
                return
            }
            songEnded = false
            self.setNewSong(songUrl: songUrl)
        }
    }
    
    // AppDelegate property
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: Notifications name
    static let playerStateChangedNotificationName: NSNotification.Name = Notification.Name("PlayerStateChanged")
    
    // MARK: - Public methods
    
    func play() {
        self.player?.play()
        NotificationCenter.default.post(name: PlayerManager.playerStateChangedNotificationName, object: nil)
    }
    
    func pause() {
        self.player?.pause()
        NotificationCenter.default.post(name: PlayerManager.playerStateChangedNotificationName, object: nil)
    }
    
    func next() {
        self.songEnded = false
        log.debug("Next: Feature not available yet...")
    }
    
    func previous() {
        self.songEnded = false
        log.debug("Previous: Feature not available yet...")
    }
    
    // MARK: - Private methods
    
    // Audio player
    private func setNewSong(songUrl: URL!) {
        do {
            let soundData = try Data(contentsOf: songUrl)
            self.player = try AVAudioPlayer(data: soundData)
            self.player?.prepareToPlay()
            self.setupPlayerDelegate()
        } catch let error as NSError {
            log.error("Error playing new iTunes preview : \(error.debugDescription)")
        }
    }
}

extension PlayerManager: AVAudioPlayerDelegate {
    func setupPlayerDelegate() {
        self.player?.delegate = self
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            log.error("Error setting audio session : \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.songEnded = true
        NotificationCenter.default.post(name: PlayerManager.playerStateChangedNotificationName, object: nil)
    }
}
