//
//  MainPageViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var messages : NSArray! = NSArray()
    
    
    override func viewDidLoad() {
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
        //self.presentViewController(loginVC!, animated: true) {
            
       // }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self .loadData()
    }
    
    func loadData(){
        
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        let params = ["access_token" : accessToken]
        Alamofire.request(.GET, urlString, parameters: params)
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("\n\n\nJSON: \(JSON)")
                    self.messages = JSON.objectForKey("statuses") as! NSArray
                    self.tableView.reloadData()
                }
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ContentCell
        let message = messages[indexPath.row]
        let avatar = message.objectForKey("user")?.objectForKey("profile_image_url") as! String
        let name = message.objectForKey("user")?.objectForKey("name") as! String
        let desc = message.objectForKey("user")?.objectForKey("description") as! String
        cell.iconButton.sd_setImageWithURL(NSURL(string: avatar)!, forState: UIControlState.Normal)
        cell.name.text = name
        cell.content.text = desc
        return cell;
    }
}
