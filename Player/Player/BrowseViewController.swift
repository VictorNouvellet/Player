//
//  BrowseViewController.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit

class BrowseViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var songs: Array<SongModel> = []
    
    // MARK: Parent methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search bar delegate using extension's method
        self.configureSearchBarDelegate()
        
        // Fetch songs
        self.fetchTop100songs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Fix Apple broken behavior with collapsing large titles
        // Problem submitted here: https://forums.developer.apple.com/thread/83262
        self.navigationItem.largeTitleDisplayMode = .always
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
    
    // MARK: Public methods
    
}

// MARK: - Table view delegate methods extension
extension BrowseViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Open the player
    }
}

// MARK: - Table view data source methods extension
extension BrowseViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        let song = self.songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artistName
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
}

// MARK: - Search bar delegate methods extension
extension BrowseViewController: UISearchBarDelegate {
    func configureSearchBarDelegate() {
        self.searchBar.delegate = self
    }
}

