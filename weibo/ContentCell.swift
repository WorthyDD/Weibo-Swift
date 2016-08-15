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
 
    func updateCell(message : Message){
        let avatar = message.imgUrl
        let userName = message.userName
        let text = message.text
        let repostsCount = message.repostsCount!
        let commentsCount = message.commentsCount!
        let attitudesCount = message.attitudesCount!
        iconButton.sd_setImageWithURL(NSURL(string: avatar!)!, forState: UIControlState.Normal)
        name.text = userName
        content.text = text
        repostsButton.setTitle(String(repostsCount), forState: UIControlState.Normal)
        commentsButton.setTitle(String(commentsCount), forState: UIControlState.Normal)
        likeButton.setTitle(String(attitudesCount), forState: UIControlState.Normal)
    }
    
    @IBAction func didTapRepostButton(sender: AnyObject) {
    }
    
    @IBAction func didTapCommentButton(sender: AnyObject) {
    }
    
    @IBAction func didTapLikeButton(sender: AnyObject) {
    }
}
