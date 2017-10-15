//
//  PlayerViewController.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit
import MarqueeLabel

class PlayerViewController: UIViewController {
    @IBOutlet var nameLabel: MarqueeLabel!
    @IBOutlet var artistLabel: MarqueeLabel!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    
    var song : SongModel? {
        return PlayerManager.shared.song
    }
    
    // MARK: Parent methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup play/pause notification
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure view
        guard let safeSong = song, let safePreviewUrl = URL(string:safeSong.iTunesPreviewUrl) else {
            print("No song loaded to player because the iTunes Preview URL is wrong")
            return
        }
        
        self.setupSongInformation(song: safeSong, songUrl: safePreviewUrl)
        self.updatePlayPauseState()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Interface Builder methods
    @IBAction func collapseButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonTouched(_ sender: Any) {
        self.play()
    }
    
    @IBAction func pauseButtonTouched(_ sender: Any) {
        self.pause()
    }
    
    @IBAction func previousButtonTouched(_ sender: Any) {
        PlayerManager.shared.previous()
    }
    
    @IBAction func nextButtonTouched(_ sender: Any) {
        PlayerManager.shared.next()
    }
    
    // MARK: public methods
    
    @objc func onPlayerStateUpdateNotification(_ notification: Notification) {
        self.updatePlayPauseState()
    }
    
    // MARK: private methods
    private func play() {
        PlayerManager.shared.play()
    }
    
    private func pause() {
        PlayerManager.shared.pause()
    }
    
    private func updatePlayPauseState() {
        if let player = PlayerManager.shared.player, player.isPlaying {
            self.playButton.isHidden = true
            self.pauseButton.isHidden = false
        } else {
            self.playButton.isHidden = false
            self.pauseButton.isHidden = true
        }
    }
    
    private func setupSongInformation(song: SongModel, songUrl: URL!) {
        self.nameLabel.text = song.name
        self.artistLabel.text = song.artistName
        self.backgroundImageView.setImageFromURL(url: song.artworkUrl)
        self.artworkImageView.setImageFromURL(url: song.artworkUrl)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPlayerStateUpdateNotification(_:)),
                                               name: PlayerManager.playerStateChangedNotificationName,
                                               object: nil)
    }
    
}
