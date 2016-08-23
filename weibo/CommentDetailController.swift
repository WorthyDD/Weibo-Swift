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
import SVProgressHUD

let commentURL = "https://api.weibo.com/2/comments/show.json"
let createCommentURL = "https://api.weibo.com/2/comments/create.json"
let replyCommentURL = "https://api.weibo.com/2/comments/reply.json"
class CommentDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var editTextField: UITextField!
    
    var commentType = 0;        // 0 评论   1  回复评论
    var message : Message?
    var commentsArr : Array<Comment>?
    var selectComment : Comment?
    var shouldFocus = false     //need show keyboard   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        self.automaticallyAdjustsScrollViewInsets = true
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableViewAutomaticDimension
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if shouldFocus{
            editTextField.becomeFirstResponder()
        }
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "comment list"
        }
        return ""
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
            let name = NSMutableAttributedString(string: "\((comment.user?.userName)!) : ", attributes: [NSForegroundColorAttributeName : UIColor.init(RGB: 0xfd6e37)])
            let content = NSAttributedString(string: comment.text!, attributes: [NSForegroundColorAttributeName : UIColor.init(RGB: 0x666666)])
            name.appendAttributedString(content)
            cell.textLabel?.attributedText = name
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0{
            return
        }
        
        selectComment = commentsArr![indexPath.row]
        editTextField.becomeFirstResponder()
        editTextField.text = "reply@\(selectComment?.user?.userName ?? "") : "
        commentType = 1
    }
    
    //Mark: edit comment
    
    func keyboardWillShow(info : NSNotification){
//        print("show---\(info.userInfo)")
        let rect = info.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let duration = info.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        UIView.animateWithDuration(duration!) { 
            self.view.centerY = SCREEN_HEIGHT/2-(rect?.height)!
        }
    }
    
    func keyboardWillHide(info : NSNotification){
//        print("hide---\(info.userInfo)")
        //let rect = info.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let duration = info.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        commentType = 0
        UIView.animateWithDuration(duration!) {
            self.view.centerY = SCREEN_HEIGHT/2
        }
    }
    
    @IBAction func didTapSend(sender: AnyObject) {
        
        if editTextField.text?.characters.count == 0 || editTextField.text?.characters.count >= 140{
            CustomToast.showHudToastWithString("comment can't be empty or over 140 words")
            return
        }
        
        if commentType == 0{
            
            let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                          "comment" : editTextField.text!,
                          "id" : "\(message!.id)"]
            Alamofire.request(.POST, createCommentURL, parameters: params).responseJSON(completionHandler: { (response : Response<AnyObject, NSError>) in
                
                self.editTextField.text = ""
                self.editTextField.resignFirstResponder()
                let error = response.result.error
                let json = response.result.value
                if error != nil{
                    print("error---\(error)")
                    CustomToast.showHudToastWithString("error:\(error)")
                }
                if json != nil{
                    print("json--- \(json)")
                    CustomToast.showHudToastWithString("comment success")
                    self.loadData()
                }
            })
            
        }
        else{
            
            let params = ["access_token" : ShareManager.shareInstance.userAccount.accessToken!,
                          "comment" : editTextField.text!,
                          "id" : "\(message!.id)",
                          "cid" : "\(selectComment!.id)"]
            Alamofire.request(.POST, createCommentURL, parameters: params).responseJSON(completionHandler: { (response : Response<AnyObject, NSError>) in
                
                self.editTextField.text = ""
                self.editTextField.resignFirstResponder()
                let error = response.result.error
                let json = response.result.value
                if error != nil{
                    print("error---\(error)")
                    CustomToast.showHudToastWithString("error:\(error)")
                }
                if json != nil{
                    print("json--- \(json)")
                    CustomToast.showHudToastWithString("reply comment success")
                    self.loadData()
                }
            })

        }
    }
    
}
