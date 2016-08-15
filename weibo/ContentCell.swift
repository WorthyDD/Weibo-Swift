//
//  ContentCell.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {

    
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var repostsButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
 
    
    @IBAction func didTapRepostButton(sender: AnyObject) {
    }
    
    @IBAction func didTapCommentButton(sender: AnyObject) {
    }
    
    @IBAction func didTapLikeButton(sender: AnyObject) {
    }
}
