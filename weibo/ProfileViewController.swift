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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfo()
    }
    
    func getUserInfo(){
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "uid" : ShareManager.shareInstance.userAccount.uid!]
        Alamofire.request(.GET, urlString, parameters: params).responseObject{ (response : Response<User, NSError>) in
            if let user = response.result.value{
                print("\nuserObject : \(user)")
//                user as User!
                
                self.updateUIWithUser(user)
            }
            
        }
        
    }
    
    func updateUIWithUser(user: User){
        
        self.iconButton.sd_setImageWithURL(NSURL(string: user.avatar!), forState: UIControlState.Normal)
        self.bio.text = user.desc?.characters.count == 0 ? "no description" : user.desc
        self.name.text = user.userName
        self.statusesLabel.text = "\(user.statusesCount)"
        self.friendsCountLabel.text = "\(user.friendsCount)"
        self.followersCountLabel.text = "\(user.followersCount)"
    }
    
}
