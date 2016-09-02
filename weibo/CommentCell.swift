//
//  CommentCell.swift
//  weibo
//
//  Created by 武淅 段 on 16/9/2.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    var comment : Comment?
    weak var controller : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCellWithComment(comment : Comment){
        
        self.comment = comment
        let name = NSMutableAttributedString(string: "\((comment.user?.userName)!) : ", attributes: [NSForegroundColorAttributeName : UIColor.init(RGB: 0xfd6e37)])
        let content = NSAttributedString(string: comment.text!, attributes: [NSForegroundColorAttributeName : UIColor.init(RGB: 0x666666)])
        name.appendAttributedString(content)
        commentLabel.attributedText = name
        iconButton.sd_setImageWithURL(NSURL(string: comment.user!.avatar!), forState: UIControlState.Normal)
    }
    
    
    @IBAction func tapIcon(sender: UIButton) {
        
        
        if controller != nil{
            let user = comment!.user!
            let profileController = controller?.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            profileController.user = user
            controller?.navigationController?.pushViewController(profileController, animated: true)
            //            profileController.updateUIWithUser((msg?.user)!)
            
        }

    }
}
