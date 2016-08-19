//
//  FriendsList.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/19.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import Foundation
import ObjectMapper

class FriendsList: Mappable {

    var users : Array<User>?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        users <- map["users"]
    }
}
