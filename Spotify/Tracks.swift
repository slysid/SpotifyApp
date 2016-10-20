//
//  Tracks.swift
//  Spotify
//
//  Created by Bharath on 17/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation


struct Track {
    
    let id:String?
    let name:String?
    let trackUri:String?
    let externalUrl:URL?
    let imageUrl:URL?
    let artistName:String?
    var albumName:String? = nil
}

extension Track {
    
    init?(json:[String:Any]) {
        
        self.id = json["id"] as? String
        self.name = json["name"] as? String
        self.trackUri = json["uri"] as? String
        self.externalUrl = URL(string: (json["external_urls"] as! [String:String])["spotify"]! as String)
        
        let album = json["album"] as? [String:Any]
        self.albumName = album?["name"] as? String
        let images = album?["images"] as! [[String:Any]]
        if images.count > 0 {
            self.imageUrl = URL(string: images.last?["url"] as! String)
        }
        else {
            self.imageUrl = nil
        }
        let artists = json["artists"] as! [[String:Any]]
        var arName:String = ""
        for artist in artists {
            
            arName = arName + (artist["name"] as! String) + ","
        }
        self.artistName = arName
        
    }
}
