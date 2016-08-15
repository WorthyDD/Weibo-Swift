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
        let params = ["access_token" : accessToken]
        Alamofire.request(.GET, urlString, parameters: params)
            .responseJSON { response in
                //                print(response.request)  // original URL request
                //                print(response.response) // URL response
                //                print(response.data)     // server data
                //                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("\n\n\nJSON: \(JSON)")
                    
                    let error = JSON.objectForKey("error")
                    if((error) != nil){
                        print("error-- \(error)")
                        return
                    }
                    let imgURL = JSON.objectForKey("profile_image_url") as! String
                    let name = JSON.objectForKey("name") as! String
                    let bio = JSON.objectForKey("domain") as! String
                    let statuses = JSON.objectForKey("statuses_count") as! NSNumber
                    let friends_count = JSON.objectForKey("friends_count") as! NSNumber
                    let followers_count = JSON.objectForKey("followers_count") as! NSNumber
                    
                    
                    self.name.text = name
                    self.iconButton.sd_setImageWithURL(NSURL(string: imgURL), forState: UIControlState.Normal)
                    self.bio.text = bio
                    self.statusesLabel.text = statuses.stringValue
                    self.friendsCountLabel.text = friends_count.stringValue
                    self.followersCountLabel.text = followers_count.stringValue
                }
        }

    }
    
}
