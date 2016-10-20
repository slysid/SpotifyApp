//
//  Album.swift
//  Spotify
//
//  Created by Bharath on 17/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation

struct Album {
    
    let id:String?
    let name:String?
    let albumUri:String?
    let externalUrl:URL?
    let imageUrl:URL?
    let albumType:String?
}

extension Album {
    
    init?(json:[String:Any]) {
        
        self.id = json["id"] as? String
        self.name = json["name"] as? String
        self.albumUri = json["uri"] as? String
        self.externalUrl = URL(string: (json["external_urls"] as! [String:String])["spotify"]! as String)
        
        let images = json["images"] as! [[String:Any]]
        if images.count > 0 {
            self.imageUrl = URL(string: images.last?["url"] as! String)
        }
        else {
            self.imageUrl = nil
        }
        
        albumType = json["album_type"] as? String
    }
}
