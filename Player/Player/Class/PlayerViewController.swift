//
//  PlayerViewController.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit
import AVKit
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
    
    var player = AVPlayer()
    var song : SongModel? = nil
    
    // MARK: Parent methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure view
        guard let safeSong = song, let safePreviewUrl = URL(string:safeSong.iTunesPreviewUrl) else {
            print("No song loaded to player because the iTunes Preview URL is wrong")
            return
        }
        self.player = AVPlayer(url: safePreviewUrl)
        self.nameLabel.text = safeSong.name
        self.artistLabel.text = safeSong.artistName
        self.backgroundImageView.setImageFromURL(url: safeSong.artworkUrl)
        self.artworkImageView.setImageFromURL(url: safeSong.artworkUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.play()
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
    
    // MARK: private methods
    private func play() {
        self.playButton.isHidden = true
        self.pauseButton.isHidden = false
        player.play()
    }
    
    private func pause() {
        self.playButton.isHidden = false
        self.pauseButton.isHidden = true
        player.pause()
    }
}
