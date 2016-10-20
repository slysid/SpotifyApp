//
//  Requests.swift
//  Spotify
//
//  Created by Bharath on 15/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation
import UIKit

var allArtists:[Artist] = []
var allAlbums:[Album] = []
var allTracks:[Track] = []
var artistTracks:[Track] = []
var albumTracks:[Track] = []

func postRequest(urlString:String,completion:@escaping ([String:Any]) ->()) {
    
    let url = URL(string: urlString)
    var urlRequest = URLRequest(url: url!)
    urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
        
        if error != nil {
            
            print("Error in API request")
        }
        else {
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            let responseDict = json as! [String:Any]
            
            completion(responseDict)
        }
    }
    
    task.resume()
}

func thumbNailData(url:URL,completion:@escaping (UIImage)->Void) {
    
    let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
        
        if error != nil {
            
            print("Error in API request")
        }
        else {
            
            completion(UIImage(data: data!)!)
        }
    }
    
    task.resume()
}

func searchByArtist(artistName:String,completion:@escaping ([Artist])->()) {
    
    if allArtists.count == 0 {
        
        let urlString = "https://api.spotify.com/v1/search?type=artist&q=" + artistName.replacingOccurrences(of: " ", with: "+") + "&limit=50"
        postRequest(urlString: urlString) { (response) in
            
            let items:[[String:Any]] = (response["artists"] as! [String:Any])["items"] as! [[String:Any]]
            for data in items {
                let artist = Artist(json: data)
                allArtists.append(artist!)
            }
            completion(allArtists)
        }
    }
    else {
        completion(allArtists)
    }
    
    
}


func searchByAlbum(albumName:String,completion:@escaping ([Album])->()) {
    
    if allAlbums.count == 0 {
        
        let urlString = "https://api.spotify.com/v1/search?type=album&q=" + albumName.replacingOccurrences(of: " ", with: "+") + "&limit=50"
        postRequest(urlString: urlString) { (response) in
            
            let items:[[String:Any]] = (response["albums"] as! [String:Any])["items"] as! [[String:Any]]
            for data in items {
                let album = Album(json: data)
                allAlbums.append(album!)
            }
            completion(allAlbums)
        }
    }
    else {
        
        completion(allAlbums)
    }
    
    
}

func searchByTrack(trackName:String,completion:@escaping ([Track])->()) {
    
    if allTracks.count == 0 {
        
        let urlString = "https://api.spotify.com/v1/search?type=track&q=" + trackName.replacingOccurrences(of: " ", with: "+") + "&limit=50"
        postRequest(urlString: urlString) { (response) in
            
            let items:[[String:Any]] = (response["tracks"] as! [String:Any])["items"] as! [[String:Any]]
            for data in items {
                let track = Track(json: data)
                allTracks.append(track!)
            }
            completion(allTracks)
        }
    }
    else {
        
        completion(allTracks)
    }
}


func searchTracksForArtist(artistId:String, completion:@escaping ([Track])->()) {
    
    artistTracks.removeAll()
    let urlString = "https://api.spotify.com/v1/artists/" + artistId + "/top-tracks?country=SE&limit=50"
    postRequest(urlString: urlString) { (response) in
        
        let items:[[String:Any]] = (response["tracks"] as? [[String:Any]])!
        for data in items {
            let track = Track(json: data)
            artistTracks.append(track!)
        }
        completion(artistTracks)
    }
}


func searchTracksForAlbum(albumId:String, albumName:String, albumImageUrl:String, completion:@escaping ([Track])->()) {
    
    albumTracks.removeAll()
    let urlString = "https://api.spotify.com/v1/albums/" + albumId + "/tracks?country=SE&limit=50"
    postRequest(urlString: urlString) { (response) in
        
        var items:[[String:Any]] = (response["items"] as? [[String:Any]])!
        
        for index in 0..<items.count {
            let album:[String:Any] = ["name":albumName,"images":[["url" : albumImageUrl]]]
            items[index]["album"] = album
        }
        for data in items {
            let track = Track(json: data)
            albumTracks.append(track!)
        }
        completion(albumTracks)
    }
}
