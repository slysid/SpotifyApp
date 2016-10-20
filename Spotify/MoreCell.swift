//
//  MoreCell.swift
//  Spotify
//
//  Created by Bharath on 17/10/16.
//  Copyright © 2016 Bharath. All rights reserved.
//

import Foundation
import UIKit

class MoreCell:UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.textAlignment = NSTextAlignment.center
        self.textLabel?.adjustsFontSizeToFitWidth = true
        self.textLabel?.font = UIFont(name: "Thonburi", size: 18.0)
        self.textLabel?.textColor = UIColor.white
        
        let bgView = UIView(frame: CGRect(x:0,y:0,width:self.frame.size.width,height:70))
        bgView.backgroundColor = UIColor.black
        self.selectedBackgroundView = bgView
    }
}
