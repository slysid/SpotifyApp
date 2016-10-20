//
//  TrackController.swift
//  Spotify
//
//  Created by Bharath on 18/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation
import UIKit


class TrackController:UITableViewController {
    
    var dataSource:[Any]? = []
    var selections:[String:Any]? = [:]
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "Tracks"
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.backgroundColor = UIColor.black
        self.loadDataSource()
    }
    
    
    func loadThumbNailForCell(cell:SummaryCell, with imageUrl:URL?) {
        
        if  imageUrl != nil {
            thumbNailData(url: imageUrl!, completion: { (thumbNailImage) in
                OperationQueue.main.addOperation {
                    cell.cellImage!.image = thumbNailImage
                }
            })
        }
        else {
            cell.cellImage!.image = UIImage(named: "noimage.png")
        }
    }
    
    func loadDataSource() {
        
        if (self.selections?["datatype"] as! String) == "Artist" {
            
            searchTracksForArtist(artistId: (self.selections?["artistid"] as! String), completion: { (data) in
                self.dataSource = data
                OperationQueue.main.addOperation {
                    
                    self.tableView!.reloadData()
                }
            })
        }
        
        if (self.selections?["datatype"] as! String) == "Album" {
            
            searchTracksForAlbum(albumId: (self.selections?["albumid"] as! String), albumName: (self.selections?["albumname"] as! String), albumImageUrl: (self.selections?["albumurl"] as! String), completion: { (data) in
                self.dataSource = data
                OperationQueue.main.addOperation {
                    
                    self.tableView!.reloadData()
                }
            })
        }
        
        if (self.selections?["datatype"] as! String) == "Track" {
            
            self.dataSource = allTracks
            self.tableView!.reloadData()
            
        }
    }
    
    
//UITableview Delegate and Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.dataSource?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "trackcell")
        if (cell == nil) {
            cell = SummaryCell(style: UITableViewCellStyle.default, reuseIdentifier: "trackcell")
        }
    
            
            (cell as! SummaryCell).cellTitle?.text = (dataSource?[indexPath.row] as! Track).name
            (cell as! SummaryCell).albumLablel!.text = "Album:" + (dataSource?[indexPath.row] as! Track).albumName!
            (cell as! SummaryCell).artistLabel!.text = "Artist:" + (dataSource?[indexPath.row] as! Track).artistName!
            self.loadThumbNailForCell(cell: cell as! SummaryCell, with: (dataSource?[indexPath.row] as! Track).imageUrl)
        
            return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIApplication.shared.openURL(allTracks[indexPath.row].externalUrl!)
    }
}
