//
//  SongCell.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    var song: SongModel? = nil
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var artworkImageView: UIImageView!
    
    func configure(song: SongModel) {
        self.song = song
        self.nameLabel.text = song.name
        self.artistLabel.text = song.artistName
        self.artworkImageView.setImageFromURL(url: song.artworkUrl)
    }
}
