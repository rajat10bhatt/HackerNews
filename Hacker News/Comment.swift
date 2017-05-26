//
//  Comment.swift
//  Hacker News
//
//  Created by Rajat Bhatt on 5/16/17.
//  Copyright © 2017 none. All rights reserved.
//

//
//	RootClass.swift
//
//	Create by Rajat Bhatt on 16/5/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class RootClass : Mappable{
    
    var by : String?
    var id : Int?
    var parent : Int?
    var text : String?
    var time : Int?
    var type : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        by <- map["by"]
        id <- map["id"]
        parent <- map["parent"]
        text <- map["text"]
        time <- map["time"]
        type <- map["type"]
        
    }
}
