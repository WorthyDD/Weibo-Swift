//
//  LoginViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/14.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {


    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUri)&response_type=code"
        let request = NSURLRequest(URL: NSURL(string: url)!)
        webView.loadRequest(request)
    }

    
    @IBAction func didTapAutoFillPassword(sender: AnyObject) {
        // js代码  注入webView  自动填充用户名和密码
        
        let js = "document.getElementById('userId').value = '1134532311@qq.com';"
        webView.stringByEvaluatingJavaScriptFromString(js)
        
    }
    
}
