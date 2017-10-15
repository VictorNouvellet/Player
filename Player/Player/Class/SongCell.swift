//
//  SongCell.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit
import MarqueeLabel

class SongCell: UITableViewCell {
    var song: SongModel? = nil
    
    @IBOutlet var nameLabel: MarqueeLabel!
    @IBOutlet var artistLabel: MarqueeLabel!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var playPauseButton: UIButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func playPauseButtonTouched(_ sender: Any) {
        if let player = PlayerManager.shared.player, player.isPlaying {
            PlayerManager.shared.pause()
            self.updateColor()
        } else {
            PlayerManager.shared.play()
            self.updateColor()
        }
    }
    
    // MARK: Public methods
    
    func configure(song: SongModel) {
        self.song = song
        self.nameLabel.text = song.name
        self.artistLabel.text = song.artistName
        self.setArtworkImage()
        
        // Setup play/pause notification
        setupNotification()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPlayerStateUpdateNotification(_:)),
                                               name: PlayerManager.playerStateChangedNotificationName,
                                               object: nil)
    }
    
    @objc func onPlayerStateUpdateNotification(_ notification: Notification) {
        self.updateColor()
    }
    
    func updateColor() {
        if let song = self.song, song.name == PlayerManager.shared.song?.name && !(PlayerManager.shared.songEnded) {
            self.backgroundColor = UIColor.darkGray
            self.nameLabel.textColor = UIColor.white
            self.artistLabel.textColor = UIColor.white
            self.nameLabel.labelize = false
            self.artistLabel.labelize = false
            self.playPauseButton.isHidden = false
            if let player = PlayerManager.shared.player, player.isPlaying {
                self.playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            } else {
                self.playPauseButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            }
        } else {
            self.backgroundColor = UIColor.white
            self.nameLabel.textColor = UIColor.black
            self.artistLabel.textColor = UIColor.black
            self.nameLabel.labelize = true
            self.artistLabel.labelize = true
            self.playPauseButton.isHidden = true
        }
    }
    
    // MARK: Private methods
    
    private func setArtworkImage() {
        self.artworkImageView.image = UIImage(named: "AppIcon")
        guard let safeUrlString = self.song?.artworkUrl, let safeUrl = URL(string: safeUrlString) else {
            return
        }
        
        if let image = SongModel.imagesCache.object(forKey: safeUrlString as NSString) {
            // Image found in cache
            self.artworkImageView.image = image
            return
        }
        
        URLSession.shared.dataTask(with: safeUrl) { (data, response, error) in
            if error != nil {
                log.error("Failed fetching image: \(error.debugDescription)")
                self.artworkImageView.image = nil
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                log.error("Error with HTTPURLResponse or statusCode")
                self.artworkImageView.image = nil
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    SongModel.imagesCache.setObject(image, forKey: safeUrlString as NSString)
                    self.artworkImageView.image = image
                }
            }
        }.resume()
    }
}
