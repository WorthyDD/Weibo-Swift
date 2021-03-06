//
//  Message.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/15.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import Foundation
import ObjectMapper

class Message: Mappable{

    var id : Int!
    var time : String?
    var userName : String?
    var text : String?
    var desc : String?
    var imgUrl : String?
    var repostsCount : Int?
    var commentsCount : Int?
    var attitudesCount : Int?
    var picUrls : NSArray?
    var retweetedStatus : Message?
    var user : User?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map : Map){
        id <- map["id"]
        time <- map["created_at"]
        userName <- map["user.name"]
        text <- map["text"]
        desc <- map["user.description"]
        imgUrl <- map["user.profile_image_url"]
        repostsCount <- map["reposts_count"]
        commentsCount <- map["comments_count"]
        attitudesCount <- map["attitudes_count"]
        picUrls <- map["pic_urls"]
        user <- map["user"]
        retweetedStatus <- map["retweeted_status"]
    }
    
    
}
