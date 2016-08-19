//
//  ProfileViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    @IBOutlet weak var iconButton: UIButton!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var statusesLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var statusesView: UIView!
    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var followSwich: UISwitch!
    var user : User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user != nil{
            updateUIWithUser(user!)
            friendsView.userInteractionEnabled = false
            statusesView.userInteractionEnabled = false
            followersView.userInteractionEnabled = false
        }
        else{
            getUserInfo()
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(didTapFollowersView(_:)))
            followersView.userInteractionEnabled = true
            followersView.addGestureRecognizer(tap1)
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(didTapFriendsView(_:)))
            friendsView.userInteractionEnabled = true
            friendsView.addGestureRecognizer(tap2)
            
        }
        
        iconButton.addTarget(self, action: #selector(didTapIconButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }
    
    func getUserInfo(){
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "uid" : ShareManager.shareInstance.userAccount.uid!]
        Alamofire.request(.GET, urlString, parameters: params).responseObject{ (response : Response<User, NSError>) in
            if let user = response.result.value{
                print("\nuserObject : \(user)")
//                user as User!
                self.user = user
                self.updateUIWithUser(user)
            }
            
        }
        
    }
    
    func updateUIWithUser(user: User){
        
        if user.id == Int(ShareManager.shareInstance.userAccount.uid!){
            followSwich.setOn(false, animated: false)
            followSwich.userInteractionEnabled = false
        }
        else{
            followSwich.setOn(user.following, animated: false)
            followSwich.userInteractionEnabled = true
        }
        self.iconButton.sd_setImageWithURL(NSURL(string: user.avatar!), forState: UIControlState.Normal)
        self.bio.text = user.desc?.characters.count == 0 ? "no description" : user.desc
        self.name.text = user.userName
        self.statusesLabel.text = "\(user.statusesCount)"
        self.friendsCountLabel.text = "\(user.friendsCount)"
        self.followersCountLabel.text = "\(user.followersCount)"
    }
    
    @IBAction func followSwichChange(sender: UISwitch) {
        
        
    }
    
    func didTapIconButton(sender : UIButton){
        
        let iv = UIImageView()
        iv.sd_setImageWithURL(NSURL(string : user?.avatarLarge ?? ""))
        iv.frame = sender.frame
        iv.contentMode = UIViewContentMode.ScaleAspectFit
        iv.userInteractionEnabled = true
        iv.backgroundColor = UIColor.blackColor()
        UIApplication.sharedApplication().keyWindow?.addSubview(iv)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapIcon(_:)))
        iv.addGestureRecognizer(tap)
        let frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        UIView.animateWithDuration(0.3, animations: {
            
            iv.frame = frame
            }) { (true) in
                iv.layer.cornerRadius = 0
        }
    }
    
    func didTapIcon(tap : UITapGestureRecognizer){
        let sender = tap.view
        UIView.animateWithDuration(0.2, animations: {
            sender!.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0)
            sender?.alpha = 0
            }) { (true) in
                sender?.removeFromSuperview()
        }
    }
    
    func didTapStatuesView(tap : UITapGestureRecognizer){
        
    }
    
    func didTapFriendsView(tap : UITapGestureRecognizer){
        let friendsVC = self.storyboard?.instantiateViewControllerWithIdentifier("FriendsListController") as! FriendsListController
        friendsVC.title = "Friends"
        if user != nil{
            friendsVC.user = user
        }
        self.navigationController?.pushViewController(friendsVC, animated: true)
    }
    
    func didTapFollowersView(tap : UITapGestureRecognizer){
        let friendsVC = self.storyboard?.instantiateViewControllerWithIdentifier("FriendsListController") as! FriendsListController
        friendsVC.title = "Followers"
        if user != nil{
            friendsVC.user = user
        }
        self.navigationController?.pushViewController(friendsVC, animated: true)
    }
}
