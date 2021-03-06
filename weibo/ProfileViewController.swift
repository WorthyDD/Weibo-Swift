//
//  ProfileViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

let mainPageSBID = "MainPageViewController"
let followURL = "https://api.weibo.com/2/friendships/create.json"
let unfollowURL = "https://api.weibo.com/2/friendships/destroy.json"

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
//            followersView.userInteractionEnabled = false
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
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(didTapStatuesView(_:)))
        statusesView.userInteractionEnabled = true
        statusesView.addGestureRecognizer(tap3)
        iconButton.addTarget(self, action: #selector(didTapIconButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }
    
    //获取用户信息
    func getUserInfo(){
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "uid" : ShareManager.shareInstance.userAccount.uid!]
        Alamofire.request(.GET, urlString, parameters: params).responseObject{ (response : Response<User, NSError>) in
            if let user = response.result.value{
                print("\nuserObject : \(user)")
//                user as User!
                self.user = user
                ShareManager.shareInstance.user = user
                if user.userName != nil{
                    self.updateUIWithUser(user)
                }
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
        
        
        //没有权限
        
        
        var urlString = ""
        if sender.on{
            //取消关注
            urlString = unfollowURL
            
        }
        else{
            //加关注
            urlString = followURL
            
        }
        
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                  "uid" : "\(user?.id)"]
        SVProgressHUD.show()
        Alamofire.request(.POST, urlString, parameters: params).responseJSON { (response : Response<AnyObject, NSError>) in
            let error = response.result.error
            let json = response.result.value
            if error != nil{
                print("error---\(error)")
                SVProgressHUD.showErrorWithStatus("error!--\(error)")
            }
            if json != nil{
                SVProgressHUD.showSuccessWithStatus("follow success!")
                print("json---\(json)")
            }
        }
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
        
        let mainPageVC = self.storyboard?.instantiateViewControllerWithIdentifier(mainPageSBID) as! MainPageViewController
        mainPageVC.entry = 1
        mainPageVC.user = self.user == nil ? ShareManager.shareInstance.user : self.user
        mainPageVC.hidesBottomBarWhenPushed = true
        mainPageVC.automaticallyAdjustsScrollViewInsets = true
        self.navigationController?.pushViewController(mainPageVC, animated: true)
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
