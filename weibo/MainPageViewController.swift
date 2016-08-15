//
//  MainPageViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import SDWebImage

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var messages:Messages!
    
    
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
        
        Alamofire.request(.GET, urlString, parameters: params).responseObject{ (response : Response<Messages, NSError>) in
         
            if let messages = response.result.value{
                print("\n\nresponseObject : \(messages)")
                self.messages = messages
                self.tableView .reloadData()
            }
            
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages==nil ? 0 : (messages.statuses?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ContentCell
        let message = messages.statuses?[indexPath.row]
        let avatar = message?.imgUrl
        let name = message?.userName
        let text = message?.text
        let repostsCount = message?.repostsCount!
        let commentsCount = message?.commentsCount!
        let attitudesCount = message?.attitudesCount!
        cell.iconButton.sd_setImageWithURL(NSURL(string: avatar!)!, forState: UIControlState.Normal)
        cell.name.text = name
        cell.content.text = text
        cell.repostsButton.setTitle("\(repostsCount)", forState: UIControlState.Normal)
        cell.commentsButton.setTitle("\(commentsCount)", forState: UIControlState.Normal)
        cell.likeButton.setTitle("\(attitudesCount)", forState: UIControlState.Normal)
        return cell;
    }
}
