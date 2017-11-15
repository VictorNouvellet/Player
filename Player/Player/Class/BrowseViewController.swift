//
//  BrowseViewController.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit
import IGListKit

class BrowseViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    var songs = [SongModel]()
    var filteredSongs = [SongModel]()
    
    // MARK: Parent methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search bar delegate using extension's method
        self.configureSearchController()
        
        // Set Previewing delegate using extension's method
        self.configurePreviewingDelegate()
        
        // Configure list
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        
        // Fetch songs
        self.fetchTop100songs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fix Apple broken behavior with collapsing large titles
        // Problem submitted here: https://forums.developer.apple.com/thread/83262
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                            NSAttributedStringKey.font: UIFont.mainBoldFont]
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    private func fetchTop100songs() {
        APIClient.shared.top100Songs { (error, response) in
            guard error == nil else {
                log.error("Error when fetching songs")
                self.songs = []
                return
            }
            let newSongs = SongModel.parseITunesSongsFromRSS(responseObject: response)
            if newSongs.count != 0 {
                self.songs = newSongs
                self.adapter.performUpdates(animated: true, completion: nil)
            } else {
                log.error("No songs")
            }
        }
    }
    
    func openPlayer(song: SongModel) {
        if PlayerManager.shared.song == nil || PlayerManager.shared.song! != song {
            // Set new song
            PlayerManager.shared.song = song
            
            // Set new Music Queue
            let songsForQueue = isFiltering() ? filteredSongs : songs
            let songIndex = songsForQueue.index(of: song)!
            PlayerManager.shared.musicQueue = Array(songsForQueue[songIndex..<songsForQueue.count]) +
                                                Array(songsForQueue[0..<songIndex])
            PlayerManager.shared.musicQueueIndex = 0
            PlayerManager.shared.play()
        }
        
        // Open the player
        self.performSegue(withIdentifier: "goto_player", sender: song)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredSongs = songs.filter({( song : SongModel) -> Bool in
            return song.name.lowercased().contains(searchText.lowercased()) ||
                    song.artistName.lowercased().contains(searchText.lowercased())
        })
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

// TODO: REMOVE
// MARK: - Table view delegate methods extension
extension BrowseViewController: UICollectionViewDelegate {
    func configureTableViewDelegate() {
        self.collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let song: SongModel
        if isFiltering() {
            song = self.filteredSongs[indexPath.row]
        } else {
            song = self.songs[indexPath.row]
        }
        
        // Open Player with context
        self.openPlayer(song: song)
    }
}

// TODO: REMOVE
// MARK: - Table view data source methods extension
extension BrowseViewController: UICollectionViewDataSource {
    func configureTableViewDataSource() {
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let song: SongModel
        let cell: SongCell = collectionView.dequeueReusableCell(withReuseIdentifier: "songCell", for: indexPath) as! SongCell
        if isFiltering() {
            song = self.filteredSongs[indexPath.row]
        } else {
            song = self.songs[indexPath.row]
        }
        cell.configure(song: song)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let songCell: SongCell = cell as? SongCell else {
            return
        }
        songCell.updateColor()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredSongs.count
        }
        return songs.count
    }
}

extension BrowseViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if isFiltering() {
            return filteredSongs as [ListDiffable]
        }
        return songs as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SongSectionController(presentingVC: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: - Search bar delegate methods extension
extension BrowseViewController: UISearchControllerDelegate {
    func configureSearchController() {
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
            
        } else {
            // TODO: Add searchbar to collectionview header
//            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.searchBar.placeholder = "Search for songs"
        
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        log.debug("Did present search controller")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        log.debug("Did dismiss search controller")
    }
}

// MARK: - Search results updating methods extension
extension BrowseViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        self.adapter.performUpdates(animated: true, completion: nil)
    }
}

// MARK: - Previewing delegate methods extension
extension BrowseViewController: UIViewControllerPreviewingDelegate {
    func configurePreviewingDelegate() {
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.collectionView)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = self.collectionView.indexPathForItem(at: location), let cell = self.collectionView.cellForItem(at: indexPath) {
            
            previewingContext.sourceRect = cell.frame
            
            let song = self.songs[indexPath.row]
            
            return viewControllerForSong(song: song)
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let songDetailVC = viewControllerToCommit as? SongDetailViewController, let song = songDetailVC.song {
            openPlayer(song:song)
        }
    }
    
    private func viewControllerForSong(song: SongModel) -> UIViewController {
        let songDetailVC = SongDetailViewController()
        songDetailVC.song = song
        return songDetailVC
    }
}
