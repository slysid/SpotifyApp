//
//  SearchTableController.swift
//  Spotify
//
//  Created by Bharath on 16/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation
import UIKit

class SearchTableController:UITableViewController {
    
    var searchText:String?
    var artistSummaryTableData:[Artist] = []
    var albumSummaryTableData:[Album] = []
    var trackSummaryTableData:[Track] = []
    var segueDataSource:[Any]?
    var segueDataType:String?
    var performSegue:Bool = true
    var artistMoreCellIndex = 0
    var albumMoreCellIndex = 0
    var trackMoreCellIndex = 0
    var selections:[String:Any]? = [:]
    
    var activity:UIActivityIndicatorView? = nil
    
    override func viewDidLoad() {
        
        activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activity?.center = CGPoint(x: self.view.frame.size.width * 0.5, y: self.view.frame.size.height * 0.20)
        self.view.addSubview(activity!)
        
        Thread.detachNewThreadSelector(#selector(startAnimating), toTarget: self, with: nil)
        
        self.navigationItem.title = "Summary"
        self.view.backgroundColor = UIColor.black
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadDataForSearchText()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.trackSummaryTableData.removeAll()
        self.albumSummaryTableData.removeAll()
        self.artistSummaryTableData.removeAll()
        
    }
    
    func startAnimating() {
        
        self.activity?.startAnimating()
    }
    
    func loadDataForSearchText() {
        
        searchByTrack(trackName: self.searchText!) { (data) in
            
            var dataCount = 3
            if data.count < 3 {
                dataCount = data.count
            }
            for index in 0..<dataCount {
                self.trackSummaryTableData.append(data[index])
            }
            
            self.trackMoreCellIndex = self.trackSummaryTableData.count
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        
        searchByArtist(artistName:self.searchText!) { (data) in
            var dataCount = 3
            if data.count < 3 {
                dataCount = data.count
            }
            for index in 0..<dataCount {
                self.artistSummaryTableData.append(data[index])
            }
            
            self.artistMoreCellIndex = self.artistSummaryTableData.count
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        
        searchByAlbum(albumName: self.searchText!) { (data) in
            
            var dataCount = 3
            if data.count < 3 {
                dataCount = data.count
            }
            for index in 0..<dataCount {
               self.albumSummaryTableData.append(data[index])
            }
            
            self.albumMoreCellIndex = self.albumSummaryTableData.count
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                self.activity?.stopAnimating()
            }

        }
        
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
    
    
    func addMore(tableView:UITableView)  -> MoreCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "morecell")
        if cell == nil {
            cell = MoreCell(style: UITableViewCellStyle.default, reuseIdentifier: "morecell")
        }
        
        cell?.textLabel!.text = ". . ."
        
        return cell! as! MoreCell
    }
    
    func getASummaryCell(tableView:UITableView) -> SummaryCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = SummaryCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        
        return cell as! SummaryCell
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return self.performSegue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier! == "toTrackFromSearch") {
            
            if (self.segueDataType == "Track") {
                
                (segue.destination as! TrackController).selections = ["datatype":"Track"]
            }
            
            if (self.segueDataType == "Album") {
                
                (segue.destination as! TrackController).selections = self.selections
            }
            
            if (self.segueDataType == "Artist") {
                
                (segue.destination as! TrackController).selections = self.selections
            }
            
        }
        else {
            
            (segue.destination as! DetailController).dataType = segueDataType!
            (segue.destination as! DetailController).dataSource = segueDataSource!
        }
    }
    

    
    
    
// UITableview Delegate and Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if (trackSummaryTableData.count == 0) {
                return trackSummaryTableData.count
            }
            else {
                return (trackSummaryTableData.count) + 1
            }
        }
        else if section == 1 {
            if (albumSummaryTableData.count == 0) {
                return albumSummaryTableData.count
            }
            else {
                
                return (albumSummaryTableData.count) + 1
            }
        }
        else if section == 2 {
            
            if (artistSummaryTableData.count == 0) {
                return artistSummaryTableData.count
            }
            else {
                return (artistSummaryTableData.count) + 1
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == self.trackSummaryTableData.count) {
                return self.addMore(tableView: tableView)
            }
            else {
                
                let cell = self.getASummaryCell(tableView: tableView)
                cell.cellTitle!.text = trackSummaryTableData[indexPath.row].name!
                self.loadThumbNailForCell(cell: cell , with: trackSummaryTableData[indexPath.row].imageUrl)
                return cell
            }
        }
        else if (indexPath.section == 1) {
            
            if (indexPath.row == self.albumSummaryTableData.count) {
                return self.addMore(tableView: tableView)
            }
            else {
                
                let cell = self.getASummaryCell(tableView: tableView)
                cell.cellTitle!.text = albumSummaryTableData[indexPath.row].name!
                self.loadThumbNailForCell(cell: cell , with: albumSummaryTableData[indexPath.row].imageUrl)
                if albumSummaryTableData[indexPath.row].albumType! == "single" {
                    cell.cellDetailTitle!.text = "Single"
                }
                return cell
            }
        }
        else {
            
            if (indexPath.row == self.artistSummaryTableData.count) {
                return self.addMore(tableView: tableView)
            }
            else {
                
                let cell = self.getASummaryCell(tableView: tableView)
                cell.cellTitle!.text = artistSummaryTableData[indexPath.row].name!
                self.loadThumbNailForCell(cell: cell , with: artistSummaryTableData[indexPath.row].imageUrl)
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 0) {
            return "Tracks"
        }
        else if (section == 1) {
            return "Albums"
        }
        else if (section == 2) {
            return  "Artists"
        }
        else{
            return ""
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == self.trackMoreCellIndex) {
                
                segueDataType = "Track"
                segueDataSource = allTracks
                self.performSegue = false
                self.performSegue(withIdentifier: "toTrackFromSearch", sender: self)
                
            }
            else {
                
                UIApplication.shared.openURL(allTracks[indexPath.row].externalUrl!)
                self.performSegue = false
                
            }
        }
        else if (indexPath.section == 1) {
            
            self.segueDataType = "Album"
            if (indexPath.row == self.albumMoreCellIndex) {
                
                segueDataSource = allAlbums
                self.performSegue = true
            }
            else {
                
                self.selections?["albumid"] = allAlbums[indexPath.row].id!
                self.selections?["albumname"] = allAlbums[indexPath.row].name!
                self.selections?["albumurl"] = allAlbums[indexPath.row].imageUrl!.absoluteString
                self.selections?["datatype"] = self.segueDataType
                self.performSegue = false
                self.performSegue(withIdentifier: "toTrackFromSearch", sender: self)
            }
        }
        else if (indexPath.section == 2) {
            
            self.segueDataType = "Artist"
            if (indexPath.row == self.artistMoreCellIndex) {
                self.segueDataSource = allArtists
                self.performSegue = true
                
            }
            else {
                
                self.selections?["artistid"] = allArtists[indexPath.row].id
                self.selections?["datatype"] = self.segueDataType
                self.performSegue = false
                self.performSegue(withIdentifier: "toTrackFromSearch", sender: self)
            }
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerTitle = ""
        
        if (section == 0) {
            headerTitle = "Tracks"
        }
        else if (section == 1) {
            headerTitle = "Albums"
        }
        else if (section == 2) {
            headerTitle =  "Artists"
        }
        
        let view = UILabel(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width:self.tableView!.frame.size.width,height:55)))
        view.backgroundColor = UIColor.black
        view.font = UIFont(name: "Thonburi", size: 22.0)
        view.textAlignment = NSTextAlignment.center
        view.textColor = UIColor.white
        view.text = headerTitle
        return view
    }
    
}
