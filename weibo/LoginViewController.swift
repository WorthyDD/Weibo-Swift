//
//  LoginViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/14.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    
    @IBOutlet weak var userIDTextField: UITextField!
    
    @IBOutlet weak var passwordTextFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func didTapLogin(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            let request: WBAuthorizeRequest! = WBAuthorizeRequest.request() as! WBAuthorizeRequest
//            request.redirectURI = "https://api.weibo.com/oauth2/default.html"
            request.redirectURI = "https://www.sina.com"
            request.scope = "all"
            
            WeiboSDK.sendRequest(request)
        }
    }
    
}
