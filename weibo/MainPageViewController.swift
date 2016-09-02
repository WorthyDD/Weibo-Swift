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


let commentDetailSegue = "commentDetailSegue"

class MainPageViewController: BaseController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    private var messages:Messages!
    var entry = 0;       //入口, 0--默认主页   1--从个人中心查看某人发的微博
    var user : User?
    lazy var refreshControl = UIRefreshControl()
    var currentPage = 1
    override func viewDidLoad() {
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(refreshControl)
        refreshControl.attributedTitle = NSAttributedString(string: "refreshing...")
        refreshControl.addTarget(self, action: #selector(loadData), forControlEvents: UIControlEvents.ValueChanged)
        
        //个人发的微博
        if entry == 1{
            self.title = "Mine Statuses"
            loadData(true)
            self.navigationItem.rightBarButtonItem = nil
        }
        else{
            //首页
            self.title = "Main"
            ShareManager.shareInstance.userAccount.readAccount()
            let expireDate = ShareManager.shareInstance.userAccount.expireDate
            if expireDate != nil &&  expireDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending{
                print("未过期")
                self.getUserInfo()
                self.loadData(true)
                
            }
            else{
                let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
                self.presentViewController(loginVC!, animated: true, completion: nil)
            }
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didGetLoginSuccessNotification(_:)), name: kLoginSuccessNotification, object: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didGetDataChangeNotification(_:)), name: kDataChangeNotification, object: nil)
        
    }
    
    // 登录成功
    func didGetLoginSuccessNotification(notifi : NSNotification){
        print("login success!!")
        self.getUserInfo()
        self.loadData(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self .loadData()
    }
    
    
    
    // MARK: - load data
    //get weibo messages from main page
    func loadData(loading : Bool){
        
        if ShareManager.shareInstance.userAccount.accessToken == nil{
            return
        }
        currentPage = 1
        var urlString = ""
        var params : [String : AnyObject]
        if entry == 1{
            urlString = "https://api.weibo.com/2/statuses/user_timeline.json"
            params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "uid" : String(user!.id!)]
        }
        else{
            urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
            params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!]
        }
        
        
        if loading{
            SVProgressHUD.show()
        }
        Alamofire.request(.GET, urlString, parameters: params).responseObject{ (response : Response<Messages, NSError>) in
            if loading{
                SVProgressHUD.dismiss()
            }
            self.refreshControl.endRefreshing()
            if let messages = response.result.value{
                print("\n\nresponseObject : \(messages)")
                self.messages = messages
                if messages.statuses == nil{
                    return
                }
                for msg in self.messages.statuses!{
                    //if there is retweeted_status
                    if msg.retweetedStatus != nil{
                        msg.text?.appendContentsOf("\nrepost content : \n\(msg.retweetedStatus!.text ?? "")")
                        msg.picUrls = msg.retweetedStatus?.picUrls
                    }

                }
                
                self.tableView .reloadData()
                if loading{
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.tableView.reloadData()
                    })
                }
            }
            
        }
        
    }
    
    
    // load more
    func loadMore() {
        
        currentPage += 1
        var urlString = ""
        if entry == 1{
//            此接口最多只返回最新的5条数据，官方移动SDK调用可返回10条；

//            urlString = "https://api.weibo.com/2/statuses/user_timeline.json"
            return
        }
        else{
            urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        }
        
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "page" : "\(currentPage)"]
//        SVProgressHUD.show()
        Alamofire.request(.GET, urlString, parameters: params).responseObject{ (response : Response<Messages, NSError>) in
//            SVProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
            let error = response.result.error
            if error != nil{
                print("error---\(error)")
                return
            }
            if let messages = response.result.value{
                print("\n\nresponseObject : \(messages)")
                if messages.statuses == nil{
                    return
                }
                for msg in messages.statuses!{
                    //if there is retweeted_status
                    if msg.retweetedStatus != nil{
                        msg.text?.appendContentsOf("\nrepost content : \n\(msg.retweetedStatus!.text ?? "")")
                        msg.picUrls = msg.retweetedStatus?.picUrls
                    }
                    
                }
                self.messages.statuses?.appendContentsOf(messages.statuses!)
                
                self.tableView .reloadData()
            }
            
        }
    }
    
    
    func getUserInfo(){
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "uid" : ShareManager.shareInstance.userAccount.uid!]
        Alamofire.request(.GET, urlString, parameters: params).responseObject{ (response : Response<User, NSError>) in
            if let user = response.result.value{
                print("\nuserObject : \(user)")
                //                user as User!
                ShareManager.shareInstance.user = user
                guard let name = user.userName else{
                    return
                }
                self.title = name
            }
            
        }
        
    }
    
    
    // MARK: - tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if messages == nil || messages.statuses == nil{
            return 0
        }
        return messages.statuses!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ContentCell
        cell.controller = self
        guard let message = messages.statuses?[indexPath.row] else{
            return cell;
        }
        cell.updateCell(message)
        return cell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // when load the last cell showing,  go to load next page data
        if indexPath.row >= messages.statuses!.count - 1{
            loadMore()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(commentDetailSegue, sender: indexPath.row)
    }
    
    @IBAction func didTapLogin(sender: AnyObject) {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(loginVC!, animated: true, completion: nil)
    }
    
    // Mark : segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == commentDetailSegue{
            let row = sender as! Int
            let message = messages.statuses?[row]
            let commentDetailVC = segue.destinationViewController as! CommentDetailController
            commentDetailVC.message = message
        }
    }
    
    
    //notification
    func didGetDataChangeNotification(notification : NSNotification){
        loadData(true)
    }
}
