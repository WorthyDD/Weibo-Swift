//
//  FriendsCell.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/19.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    var user : User?
    
    func updateCellWithUser(user : User){
        
        self.user = user
        nameLabel.text = user.userName
        iconButton.sd_setImageWithURL(NSURL(string: user.avatar!), forState: UIControlState.Normal)
        descLabel.text = user.desc?.characters.count == 0 ? "no description" : user.desc
        
    }
}
