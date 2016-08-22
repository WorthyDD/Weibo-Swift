//
//  CommentDetailController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/22.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

let commentURL = "https://api.weibo.com/2/comments/show.json"

class CommentDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    var message : Message?
    var commentsArr : Array<Comment>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableViewAutomaticDimension
        loadData()
    }
    
    func loadData(){
        
        let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                      "id" : "\(message!.id)"]
        Alamofire.request(.GET, commentURL, parameters: params).responseObject { (response : Response<Comments, NSError>) in
            
            let comments = response.result.value
            let error = response.result.error
            
            if error != nil{
                print("error--- \(error)")
                return
            }
            
            if comments != nil{
                self.commentsArr = comments?.comments
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return commentsArr == nil ? 0 : (commentsArr?.count)!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.1
        }
        else{
            return 10
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! ContentCell
            cell.updateCell(message!)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath)
            let comment = commentsArr![indexPath.row]
            let name = NSMutableAttributedString(string: "\((comment.user?.userName)!) :", attributes: [NSForegroundColorAttributeName : UIColor.init(RGB: 0xfd6e37)])
            let content = NSAttributedString(string: comment.text!, attributes: [NSForegroundColorAttributeName : UIColor.init(RGB: 0x666666)])
            name.appendAttributedString(content)
            cell.textLabel?.attributedText = name
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
}
