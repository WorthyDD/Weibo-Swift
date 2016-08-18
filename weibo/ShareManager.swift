//
//  ShareManager.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/14.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper


let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
let appKey = "3536233261"
let secretKey = "d357a2dc8c79116311af6ef1e44fc3b0"
let redirectUri = "http://www.baidu.com"
let kLoginSuccessNotification = "login_success"

//https://api.weibo.com/oauth2/authorize?client_id=3536233261&redirect_uri=http://www.baidu.com&response_type=code
class ShareManager: NSObject {

    static let shareInstance = ShareManager()
    
    
    lazy var userAccount = UserAccount()
    
    private override init() {
        
    }
    
}

extension ShareManager{
    
    func getAccessToken(code :String){
        
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":appKey,
                      "client_secret":secretKey,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":redirectUri]
        
        Alamofire.request(.POST, urlStr, parameters: params).responseJSON { (response : Response) in
            
            let error = response.result.error
            let json = response.result.value
            if error != nil{
                print("error--- \(error)")
                return
            }
            if json != nil{
                print("json--- \(json)")
                if json?.objectForKey("access_token") != nil{
                    self.userAccount.accessToken = json?.objectForKey("access_token") as? String
                    self.userAccount.uid = json?.objectForKey("uid") as? String
                    let seconds = json?.objectForKey("expires_in") as? NSNumber
                    if seconds != nil{
                        self.userAccount.expireTime = Double((seconds?.integerValue)!)
                        self.userAccount.expireDate = NSDate(timeInterval: self.userAccount.expireTime, sinceDate: NSDate())
                        self.userAccount.desc()
                        self.userAccount.saveAccount()
                        
                        
                        self.userAccount.saveAccount()
//                        print("save success!")
//                        self.userAccount.readAccount()
//                        print("read success!")
//                        self.userAccount.desc()
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(kLoginSuccessNotification, object: nil)
                }
            }
        }
    }
    
}