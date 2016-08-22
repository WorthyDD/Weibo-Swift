//
//  FriendsListController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/19.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import SVProgressHUD

class FriendsListController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var user : User?
    var friends : Array<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user != nil{
            getData("\(user!.id)")
        }
        else{
            getData(ShareManager.shareInstance.userAccount.uid!)
        }
    }
    
    func getData(uid : String){
        var urlStr = ""
        if self.title == "Friends"{
            urlStr = "https://api.weibo.com/2/friendships/friends.json"
        }
        else if self.title == "Followers"{
            urlStr = "https://api.weibo.com/2/friendships/followers.json"
        }
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "uid" : uid,
                      "count" : "200"]
        SVProgressHUD.show()
        Alamofire.request(.GET, urlStr, parameters: params).responseObject { (response : Response<FriendsList, NSError>) in
            SVProgressHUD.dismiss()
            let error = response.result.error
            let userList = response.result.value
            
            if error != nil{
                print("error---\(error)")
            }
            if userList != nil{
                print("firends list---\(userList)")
                self.friends = userList!.users
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends != nil ? friends!.count : 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FriendsCell
        let user = friends![indexPath.row]
        cell.updateCellWithUser(user)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let user = friends![indexPath.row]
        let profileController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileController.user = user
        self.navigationController?.pushViewController(profileController, animated: true)
        
    }
}
