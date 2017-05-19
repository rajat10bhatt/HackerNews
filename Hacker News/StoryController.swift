//
//  StoryController.swift
//  Hacker News
//
//  Created by Rajat Bhatt on 5/19/17.
//  Copyright © 2017 none. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

class StoryController{
    
    static let storySaredInstance = StoryController()
    
    let disposeBag = DisposeBag()
    let topStories = Observable.from(Story.topStories)
    func getTopStories(itemID: Int) {
        let sourceStringURL = hackerNewsUrls.baseURL + hackerNewsUrls.getTopStories
        RxAlamofire.requestJSON(.get, sourceStringURL)
            .debug()
            .subscribe(onNext: { (r, json) in
                if let dict = json as? Story {
                    //                    let valDict = dict["rates"] as! Dictionary<String, AnyObject>
                    //                    if let conversionRate = valDict["USD"] as? Float {
                    //                        self?.toTextField.text = formatter
                    //                            .string(from: NSNumber(value: conversionRate * fromValue))
                    //                    }
                    Story.topStories.append(dict)
                    print(dict)
                }
            }, onError: { (error) in
                print(error as NSError)
            })
            .addDisposableTo(disposeBag)
    }
}
