//
//  Comment.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/22.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Mappable {

    
    var id : Int!
    var text : String?
    var source : String?
    var user : User?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        text <- map["text"]
        source <- map["source"]
        user <- map["user"]
    }
}

class Comments : Mappable{
    
    var comments : Array<Comment>?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        comments <- map["comments"]
    }

}
