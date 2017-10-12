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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Search bar delegate using extension's method
        self.configureSearchBarDelegate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Table view delegate methods extension
extension BrowseViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Do something
    }
}

// MARK: - Table view data source methods extension
extension BrowseViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        cell.textLabel?.text = "Mask Off"
        cell.detailTextLabel?.text = "The Chainsmokers"
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}

// MARK: - Search bar delegate methods extension
extension BrowseViewController: UISearchBarDelegate {
    func configureSearchBarDelegate() {
        self.searchBar.delegate = self
    }
}

