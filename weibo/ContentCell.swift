//
//  ContentCell.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

let repostURL = "https://api.weibo.com/2/statuses/repost.json"

class ContentCell: UITableViewCell {

    
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var repostsButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageContainerHeight: NSLayoutConstraint!

    weak var controller : MainPageViewController?
    var msg : Message?
    
    
    func updateCell(message : Message){
        
        self.msg = message
        let avatar = message.imgUrl
        let userName = message.userName
        let text = message.text
        let time = message.time
        let repostsCount = message.repostsCount!
        let commentsCount = message.commentsCount!
        let attitudesCount = message.attitudesCount!
        iconButton.sd_setImageWithURL(NSURL(string: avatar!)!, forState: UIControlState.Normal)
        name.text = userName
        content.text = text
        timeLabel.text = time
        repostsButton?.setTitle(String(repostsCount), forState: UIControlState.Normal)
        commentsButton?.setTitle(String(commentsCount), forState: UIControlState.Normal)
        likeButton?.setTitle(String(attitudesCount), forState: UIControlState.Normal)
        updateImageContainer(message.picUrls!)
    }
    
    func updateImageContainer(images : NSArray){
        let width = imageContainer.width/3
        for view in imageContainer.subviews{
            view.removeFromSuperview()
        }

        if images.count == 0{
            imageContainerHeight.constant = 0
        }
        else{
            let count = images.count
            let row = ceil(Double(count)/3.0)
            
            imageContainerHeight.constant = width*CGFloat(row)
            for i in 0...count-1{
                let row = CGFloat(i/3)
                let column = CGFloat(i%3)
                let x = column*width
                let y = row*width
                let gap = CGFloat(10)
                let im = images[i].objectForKey("thumbnail_pic") as! String
                let iv = UIImageView()
                iv.sd_setImageWithURL(NSURL(string: im))
                iv.clipsToBounds = true
                iv.contentMode = UIViewContentMode.ScaleAspectFill
                iv.frame = CGRectMake(x+gap, y+gap, width-gap*2, width-gap*2)
                iv.tag = i
                imageContainer.addSubview(iv)
                iv.userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(ContentCell.didTapImage(_:)))
                iv.addGestureRecognizer(tap)
                
            }
        }
    }
    
    
    func didTapImage(tap : UITapGestureRecognizer){
        
        
        let vc = controller?.storyboard?.instantiateViewControllerWithIdentifier("ImageCheckerController") as! ImageCheckerController
        vc.images = msg?.picUrls
        vc.index = tap.view!.tag        //序号
        controller?.navigationController?.pushViewController(vc, animated: true)
        
        /*
        let iv = tap.view as! UIImageView
        let ivLarge = UIImageView()
        ivLarge.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0)
        ivLarge.image = iv.image
        ivLarge.contentMode = UIViewContentMode.ScaleAspectFit
        ivLarge.clipsToBounds = true
        ivLarge.userInteractionEnabled = true
        UIApplication.sharedApplication().keyWindow?.addSubview(ivLarge)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ContentCell.touchImageLarge(_:)))
        ivLarge.addGestureRecognizer(tap)
        ivLarge.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(0.3, animations: {
            ivLarge.frame = UIScreen.mainScreen().bounds
            }) { (true) in
                
        }*/
    }
    
    func touchImageLarge(tap : UITapGestureRecognizer){
        let ivLarge = tap.view!
        UIView.animateWithDuration(0.3, animations: {
            ivLarge.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0)
            ivLarge.alpha = 0
        }) { (true) in
            ivLarge.removeFromSuperview()
        }

    }
    @IBAction func didTapRepostButton(sender: AnyObject) {
        
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "id" : "\(msg!.id)"]
        Alamofire.request(.POST, repostURL, parameters: params).responseJSON {
            (response : Response<AnyObject,NSError>) in
            if response.result.value != nil{
                let error = response.result.value?.objectForKey("error")
                if error != nil{
                    CustomToast.showHudToastWithString("error, \(error)")
                    return
                }
                
                CustomToast.showHudToastWithString("repost success!")
                NSNotificationCenter.defaultCenter().postNotificationName(kDataChangeNotification, object: nil)
            }
        }
    }
    
    @IBAction func didTapCommentButton(sender: AnyObject) {
        
        if controller != nil{
            
            let commentDetailVC = controller?.storyboard?.instantiateViewControllerWithIdentifier("CommentDetailController") as! CommentDetailController
            commentDetailVC.message = msg
            commentDetailVC.shouldFocus = true
            controller?.navigationController?.pushViewController(commentDetailVC, animated: true)
        }
    }
    
    @IBAction func didTapLikeButton(sender: AnyObject) {
        
        let zanButton = sender as! UIButton
        let zan = UIImageView(image: UIImage(named: "like-blue"))
        zan.frame = zanButton.frame
        zan.contentMode = UIViewContentMode.ScaleAspectFit
        zanButton.superview?.addSubview(zan)
        
        UIView.animateWithDuration(0.3, animations: {
            
            zan.transform = CGAffineTransformMakeScale(2, 2)
            zan.alpha = 0
            
            }) { (true) in
                zan.removeFromSuperview()
                zanButton.setImage(UIImage(named: "like-blue"), forState: UIControlState.Normal)
                self.msg?.attitudesCount! += 1
                self.updateCell(self.msg!)
        }
        
        
    }
    
    @IBAction func didTapIconButton(sender: AnyObject) {
        
        if controller != nil{
            let profileController = controller?.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            profileController.user = msg?.user
            controller?.navigationController?.pushViewController(profileController, animated: true)
//            profileController.updateUIWithUser((msg?.user)!)
            
        }
    }
    
}
