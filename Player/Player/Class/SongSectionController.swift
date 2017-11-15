//
//  SongSectionController.swift
//  Player
//
//  Created by Victor Nouvellet on 15/11/2017.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit
import IGListKit

final class SongSectionController: ListSectionController {
    
    private var song: SongModel!
    weak var presentingVC: UIViewController?
    
    init(presentingVC: UIViewController? = nil) {
        super.init()
        self.presentingVC = presentingVC
    }
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        return CGSize(width: context.containerSize.width, height: 90)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: "SongCell", for: self, at: index)
        if let cell = cell as? SongCell {
            cell.configure(song: self.song)
            return cell
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.song = object as? SongModel
    }
    
    override func didSelectItem(at index: Int) {
        if let browseVC = self.presentingVC as? BrowseViewController {
            browseVC.openPlayer(song: self.song)
        }
    }
}
