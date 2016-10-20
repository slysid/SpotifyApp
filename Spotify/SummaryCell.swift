//
//  SummaryCell.swift
//  Spotify
//
//  Created by Bharath on 16/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation
import UIKit

class SummaryCell:UITableViewCell {
    
    @IBOutlet weak var cellImage:UIImageView?
    @IBOutlet weak var cellTitle:UILabel?
    @IBOutlet weak var cellDetailTitle:UILabel?
    @IBOutlet weak var artistLabel:UILabel?
    @IBOutlet weak var albumLablel:UILabel?
    
    var artistID:String? = nil
    var albumID:String? = nil
    var trackID:String? = nil
    var imageURL:URL? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let bgView = UIView(frame: CGRect(x:0,y:0,width:self.frame.size.width,height:70))
        bgView.backgroundColor = UIColor.black
        self.selectedBackgroundView = bgView
    }
}
