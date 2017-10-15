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
    
    var musicQueueIndex = 0
    var musicQueue = [SongModel]()
    
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
        let wasPlaying: Bool = self.player?.isPlaying ?? false
        self.musicQueueIndex += 1
        if musicQueueIndex > musicQueue.count-1 {
            self.musicQueueIndex = 0
        }
        self.song = self.musicQueue[musicQueueIndex]
        if wasPlaying {
            self.player?.play()
        }
        NotificationCenter.default.post(name: PlayerManager.playerStateChangedNotificationName, object: nil)
    }
    
    func previous() {
        let wasPlaying: Bool = self.player?.isPlaying ?? false
        musicQueueIndex -= 1
        if musicQueueIndex < 0 {
            self.musicQueueIndex = (musicQueue.count == 0) ? 0 : musicQueue.count - 1
        }
        self.song = musicQueue[musicQueueIndex]
        if wasPlaying {
            self.player?.play()
        }
        NotificationCenter.default.post(name: PlayerManager.playerStateChangedNotificationName, object: nil)
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
