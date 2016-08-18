//
//  UserAccount.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/18.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import Foundation
let kAccessTokenKey = "access_token_key"

class UserAccount: NSObject {

    var accessToken : String?
    var uid : String?
    
    //过期时间  开发者 : 5年   普通用户 : 3天
    var expireTime : NSTimeInterval = 0
    var expireDate : NSDate?
    
    func desc(){
        print("access_token : \(accessToken)\nuid : \(uid)\nexpire_date : \(expireDate)\n")
    }
    
    func saveAccount(){
        let dic = ["accessToken" : accessToken ?? "",
                   "uid" : uid ?? "",
                   "expireDate" : expireDate ?? NSDate()]
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: kAccessTokenKey)
    }
    
    func readAccount(){
        let dic = NSUserDefaults.standardUserDefaults().objectForKey(kAccessTokenKey)
        if dic != nil{
            accessToken = dic?.objectForKey("accessToken") as? String
            uid = dic?.objectForKey("uid") as? String
            expireDate = dic?.objectForKey("expireDate") as? NSDate
        }
    }
}
