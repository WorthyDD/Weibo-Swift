//
//  LoginViewController.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/14.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import SVProgressHUD


class LoginViewController: UIViewController {


    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUri)&response_type=code"
        let request = NSURLRequest(URL: NSURL(string: url)!)
        webView.scrollView.scrollEnabled = false
        webView.loadRequest(request)
        webView.delegate = self
    }

    
    @IBAction func didTapAutoFillPassword(sender: AnyObject) {
        // js代码  注入webView  自动填充用户名和密码
        
        let js = "document.getElementById('userId').value = '1134532311@qq.com';"
        webView.stringByEvaluatingJavaScriptFromString(js)
        
    }
    
}

extension LoginViewController : UIWebViewDelegate{
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.URL?.absoluteString.hasPrefix(redirectUri) == false{
            return true
        }
        
        if request.URL?.query?.hasPrefix("code=") == false{
            
            print("取消授权")
            SVProgressHUD.dismiss()
            dismissViewControllerAnimated(true, completion: nil)
            return false
            
        }
        
        let code = request.URL?.query?.substringFromIndex("code=".endIndex)
        print("授权码 : \(code!)")
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true) { 
            ShareManager.shareInstance.getAccessToken(code!)
        }
        return false
        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
