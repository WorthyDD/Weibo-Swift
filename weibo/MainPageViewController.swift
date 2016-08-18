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
import SVProgressHUD

class MainPageViewController: BaseController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    private var messages:Messages!
    
    override func viewDidLoad() {
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        ShareManager.shareInstance.userAccount.readAccount()
        let expireDate = ShareManager.shareInstance.userAccount.expireDate
        if expireDate != nil &&  expireDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending{
            print("未过期")
            self.loadData()
            
        }
        else{
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(loginVC!, animated: true, completion: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didGetLoginSuccessNotification(_:)), name: kLoginSuccessNotification, object: nil)
    }
    
    func didGetLoginSuccessNotification(notifi : NSNotification){
        print("login success!!")
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self .loadData()
    }
    
    func loadData(){
        
        if ShareManager.shareInstance.userAccount.accessToken == nil{
            return
        }
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!]
        SVProgressHUD.show()
        Alamofire.request(.GET, urlString, parameters: params).responseObject{ (response : Response<Messages, NSError>) in
            SVProgressHUD.dismiss()
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
        cell.updateCell(message!)
        return cell;
    }
    
    @IBAction func didTapLogin(sender: AnyObject) {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(loginVC!, animated: true, completion: nil)
    }
    
}
