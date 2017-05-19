//
//  StoriesModel.swift
//  Hacker News
//
//  Created by Rajat Bhatt on 5/16/17.
//  Copyright © 2017 none. All rights reserved.
//

import Foundation
import ObjectMapper


class Story : Mappable {
    
    static var topStories: [Story] = []
    var by : String?
    var descendants : Int?
    var id : Int?
    var kids : [Int]?
    var score : Int?
    var time : Int?
    var title : String?
    var type : String?
    var url : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map)
    {
        by <- map["by"]
        descendants <- map["descendants"]
        id <- map["id"]
        kids <- map["kids"]
        score <- map["score"]
        time <- map["time"]
        title <- map["title"]
        type <- map["type"]
        url <- map["url"]
        
    }
}
