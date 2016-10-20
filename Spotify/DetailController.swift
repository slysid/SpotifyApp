//
//  DetailController.swift
//  Spotify
//
//  Created by Bharath on 17/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation
import UIKit

class DetailController:UITableViewController {
    
    var dataSource:[Any] = []
    var dataType:String = ""
    var selectedEntityID:String? = ""
    var selections:[String:Any]? = [:]
    
    override func viewDidLoad() {
        
        self.navigationItem.title = self.dataType
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.backgroundColor = UIColor.black
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        (segue.destination as! TrackController).selections = self.selections
        
    }

    
    
// UITableview Delegate And DataSource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "detailcell")
        if cell == nil {
            cell = SummaryCell(style: UITableViewCellStyle.default, reuseIdentifier: "detailcell")
        }
        
        if (self.dataType == "Artist") {
            (cell as! SummaryCell).cellTitle?.text = (dataSource[indexPath.row] as! Artist).name
            (cell as! SummaryCell).artistID = (dataSource[indexPath.row] as! Artist).id
            (cell as! SummaryCell).imageURL = (dataSource[indexPath.row] as! Artist).imageUrl
            self.loadThumbNailForCell(cell: cell as! SummaryCell, with: (dataSource[indexPath.row] as! Artist).imageUrl)
        }
        
        if (self.dataType == "Album") {
            (cell as! SummaryCell).cellTitle?.text = (dataSource[indexPath.row] as! Album).name
            (cell as! SummaryCell).albumID = (dataSource[indexPath.row] as! Album).id
            (cell as! SummaryCell).imageURL = (dataSource[indexPath.row] as! Album).imageUrl
            self.loadThumbNailForCell(cell: cell as! SummaryCell, with: (dataSource[indexPath.row] as! Album).imageUrl)
        }
        
        if (self.dataType == "Track") {
            (cell as! SummaryCell).cellTitle?.text = (dataSource[indexPath.row] as! Track).name
            (cell as! SummaryCell).albumLablel!.text = "Album:" + (dataSource[indexPath.row] as! Track).albumName!
            (cell as! SummaryCell).artistLabel!.text = "Artist:" + (dataSource[indexPath.row] as! Track).artistName!
            self.loadThumbNailForCell(cell: cell as! SummaryCell, with: (dataSource[indexPath.row] as! Track).imageUrl)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let cell = tableView.cellForRow(at: indexPath)
        self.selections?["datatype"] = self.dataType
        
        if (self.dataType == "Artist") {
            self.selectedEntityID = (cell as! SummaryCell).artistID!
            self.selections?["artistid"] = (cell as! SummaryCell).artistID!
        }
        else if (self.dataType == "Album") {
            self.selections?["albumid"] = (cell as! SummaryCell).albumID!
            self.selections?["albumname"] = (cell as! SummaryCell).cellTitle?.text
            self.selections?["albumurl"] = (cell as! SummaryCell).imageURL?.absoluteString
        }
        
        
        return indexPath
    }
}
