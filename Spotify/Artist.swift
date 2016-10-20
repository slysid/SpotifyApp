//
//  Artist.swift
//  Spotify
//
//  Created by Bharath on 16/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation

struct Artist {
    
    let id:String?
    let name:String?
    let artistUri:String?
    let externalUrl:URL?
    let imageUrl:URL?
    
}

extension Artist {
    
    init?(json:[String:Any]) {
        
        self.id = json["id"] as? String
        self.name = json["name"] as? String
        self.artistUri = json["uri"] as? String
        self.externalUrl = URL(string: (json["external_urls"] as! [String:String])["spotify"]! as String)
        
        let images = json["images"] as! [[String:Any]]
        if images.count > 0 {
            self.imageUrl = URL(string: images.last?["url"] as! String)
        }
        else {
            self.imageUrl = nil
        }
    }
    
}
