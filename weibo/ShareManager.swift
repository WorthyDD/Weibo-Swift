//
//  ShareManager.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/14.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import UIKit


let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
let appKey = "3536233261"
let secretKey = "d357a2dc8c79116311af6ef1e44fc3b0"
let accessToken = "2.00Qzo9GD0jBbd62feaa49008iNLTQC"
let redirectUri = "http://www.baidu.com"

//https://api.weibo.com/oauth2/authorize?client_id=3536233261&redirect_uri=http://www.baidu.com&response_type=code
class ShareManager: NSObject {

    static let shareInstance = ShareManager()
    
    private override init() {
        
    }
    
}


