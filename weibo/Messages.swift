//
//  Messages.swift
//  weibo
//
//  Created by 武淅 段 on 16/8/15.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

import Foundation
import ObjectMapper

class Messages: Mappable {

    var statuses : [Message]?
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        statuses <- map["statuses"]
    }
    
    
}
