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
    
    override var previewActionItems: [UIPreviewActionItem] {
        let playing: Bool = (PlayerManager.shared.song == self.song && PlayerManager.shared.player?.isPlaying ?? false)
        let playAction = UIPreviewAction(title: (playing ? "Pause" : "Play"), style: .default) { (action, viewController) in
            if playing {
                PlayerManager.shared.pause()
            } else {
                if PlayerManager.shared.song != self.song { PlayerManager.shared.song = self.song }
                PlayerManager.shared.play()
            }
        }
        let shareAction = UIPreviewAction(title: "Share", style: .default) { (action, viewController) in
            guard let iTunesUrlString = self.song?.iTunesUrl, let iTunesUrl = URL(string: iTunesUrlString) else {
                log.error("Error when sharing song : iTunes URL is wrong")
                return
            }
            log.debug("Action: \(action), viewcontroller: \(viewController)")
            let activityController = UIActivityViewController(activityItems: [iTunesUrl], applicationActivities: nil)
            
            UIApplication.shared.keyWindow!.rootViewController!.childViewControllers.last!.present(activityController, animated: true, completion: {
                // Do something when shared
            })
        }
        return [playAction, shareAction]
    }
}
