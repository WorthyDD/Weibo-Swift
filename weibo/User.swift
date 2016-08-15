//
//  User.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/15.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import Foundation
import ObjectMapper

class User:Mappable{

    var userName : String?
    var avatar : String?
    var avatarLarge : String?
    var id : Int!
    var desc : String?
    var gender : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userName <- map["name"]
        avatar <- map["profile_image_url"]
        avatarLarge <- map["avatar_large"]
        id <- map["id"]
        desc <- map["description"]
        gender <- map["gender"]
    }
}