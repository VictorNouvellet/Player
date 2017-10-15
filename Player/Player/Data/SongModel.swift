//
//  SongModel.swift
//  Player
//
//  Created by Victor Nouvellet on 10/12/17.
//  Copyright © 2017 Victor Nouvellet. All rights reserved.
//

import UIKit

struct SongModel {
    let iTunesId: String
    let name: String
    let artistName: String
    let artworkUrl: String
    let iTunesPreviewUrl: String
    let iTunesUrl: String
    
    static let imagesCache = NSCache<NSString,UIImage>()
}

extension SongModel {
    /// Parse result of https://itunes.apple.com/FR/rss/topsongs/limit=10/json
    static func parseITunesSongsFromRSS(responseObject: Any?) -> Array<SongModel> {
        guard let safeOriginObject = responseObject as? Dictionary<String, Any>,
            let safeFeed = safeOriginObject["feed"] as? Dictionary<String, Any>,
            let safeResults = safeFeed["entry"] as? Array<Any>
            else {
                return []
        }
        
        var songs: Array<SongModel> = []
        
        for songJSON in safeResults {
            if let song = SongModel.parseITunesSong(responseObject: songJSON) {
                songs.append(song)
            }
        }
        
        return songs
    }
    
    /// Parse individual entry of https://itunes.apple.com/FR/rss/topsongs/limit=10/json
    static func parseITunesSong(responseObject: Any?) -> SongModel? {
        guard let safeSongObject = responseObject as? Dictionary<String, Any>
            else {
                return nil
        }
        
        var iTunesId: String? = nil
        if let id = safeSongObject["id"] as? Dictionary<String, Any>,
            let attributes = id["attributes"] as? Dictionary<String, Any> {
                iTunesId = attributes["im:id"] as? String
        }
        
        var name: String? = nil
        if let imName = safeSongObject["im:name"] as? Dictionary<String, Any> { name = imName["label"] as? String }
        
        var artistName: String? = nil
        if let imArtist = safeSongObject["im:artist"] as? Dictionary<String, Any> {
            artistName = imArtist["label"] as? String
        }
        
        var artworkUrl: String? = nil
        if let imImages = safeSongObject["im:image"] as? Array<Dictionary<String, Any>> {
            for image in imImages {
                if let attributes = image["attributes"] as? Dictionary<String, Any>,
                    let height = attributes["height"] as? String,
                    let imageUrl = image["label"] as? String, height == "170" {
                    // Little hack to have better resolution
                    let betterResolutionImageUrl = imageUrl.replacingOccurrences(of: "170x170", with: "300x300")
                    artworkUrl = betterResolutionImageUrl
                }
            }
        }
        
        var iTunesUrl: String? = nil
        var iTunesPreviewUrl: String? = nil
        if let links = safeSongObject["link"] as? Array<Dictionary<String, Any>> {
            for link in links {
                if let attributes = link["attributes"] as? Dictionary<String, Any>,
                    let rel = attributes["rel"] as? String,
                    let href = attributes["href"] as? String {
                    switch rel {
                    case "alternate":
                        iTunesUrl = href
                        break
                    case "enclosure":
                        iTunesPreviewUrl = href
                    default:
                        break
                    }
                }
            }
        }
        
        if (iTunesId != nil) && (name != nil) && (artistName != nil) && (artworkUrl != nil) {
            return SongModel(iTunesId: iTunesId!, name: name!, artistName: artistName!, artworkUrl: artworkUrl!, iTunesPreviewUrl: iTunesPreviewUrl!, iTunesUrl: iTunesUrl!)
        }
        
        return nil
    }
}

extension SongModel: Equatable {
    static func ==(lhs: SongModel, rhs: SongModel) -> Bool {
        return lhs.iTunesId == rhs.iTunesId
    }
}
