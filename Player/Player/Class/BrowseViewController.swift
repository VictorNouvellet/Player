//
//  BrowseViewController.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var songs: Array<SongModel> = []
    
    // MARK: Parent methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Table View delegate using extension's method
        self.configureTableViewDelegate()
        
        // Set Table View datasource using extension's method
        self.configureTableViewDataSource()
        
        // Set Search bar delegate using extension's method
        self.configureSearchController()
        
        // Fetch songs
        self.fetchTop100songs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Fix Apple broken behavior with collapsing large titles
        // Problem submitted here: https://forums.developer.apple.com/thread/83262
        self.navigationItem.largeTitleDisplayMode = .always
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
                print("Error when fetching songs")
                self.songs = []
                self.tableView.reloadData()
                return
            }
            let newSongs = SongModel.parseITunesSongsFromRSS(responseObject: response)
            if newSongs.count != 0 {
                self.songs = newSongs
            } else {
                print("No songs")
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table view delegate methods extension
extension BrowseViewController: UITableViewDelegate {
    func configureTableViewDelegate() {
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let song = self.songs[indexPath.row]
        
        if PlayerManager.shared.song == nil || PlayerManager.shared.song! != song {
            // Set new song
            PlayerManager.shared.song = song
            PlayerManager.shared.play()
        }
        
        // Open the player
        self.performSegue(withIdentifier: "goto_player", sender: song)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: - Table view data source methods extension
extension BrowseViewController: UITableViewDataSource {
    func configureTableViewDataSource() {
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = self.songs[indexPath.row]
        let cell: SongCell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongCell
        cell.configure(song: song)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let songCell: SongCell = cell as? SongCell else {
            return
        }
        songCell.updateColor()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
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
            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.searchBar.searchBarStyle = .minimal
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        print("Did present search controller")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("Did dismiss search controller")
    }
}

extension BrowseViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: Do more...
    }
    
    
}
