//
//  SongDetailViewController.swift
//  Player
//
//  Created by Victor Nouvellet on 10/15/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController {
    var song: SongModel? = nil {
        didSet {
            guard let song = song else {
                return
            }
            fillView(song: song)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fillView(song: SongModel) {
        let artworkImageView = UIImageView(frame: self.view.frame)
        artworkImageView.contentMode = .scaleAspectFit
        self.view.addSubview(artworkImageView)
        artworkImageView.bounds.origin = self.view.bounds.origin
        artworkImageView.setImageFromURL(url: song.artworkUrl)
    }
}
