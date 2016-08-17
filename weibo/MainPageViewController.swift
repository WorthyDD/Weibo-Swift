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

class MainPageViewController: BaseController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    private var messages:Messages!
    private var acIndicator : UIActivityIndicatorView! = nil
    
    override func viewDidLoad() {
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        acIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        acIndicator.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        acIndicator.hidesWhenStopped = true
        acIndicator.startAnimating()
        self.tableView.addSubview(acIndicator)
        
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(loginVC!, animated: true, completion: nil)
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
                self.acIndicator.stopAnimating()
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
        cell.updateCell(message!)
        return cell;
    }
}
