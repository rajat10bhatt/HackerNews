//
//  TopStoriesController.swift
//  Hacker News
//
//  Created by Rajat Bhatt on 5/18/17.
//  Copyright © 2017 none. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

class TopStoriesController{
    
    static let topStoriesSaredInstance = TopStoriesController()
    
    let disposeBag = DisposeBag()
    let topStories = Observable.from(TopStories.topStories)
    func getTopStories() {
        let sourceStringURL = hackerNewsUrls.baseURL + hackerNewsUrls.getTopStories
        RxAlamofire.requestJSON(.get, sourceStringURL)
            .debug()
            .subscribe(onNext: { [weak self] (r, json) in
                if let dict = json as? [Int] {
//                    let valDict = dict["rates"] as! Dictionary<String, AnyObject>
//                    if let conversionRate = valDict["USD"] as? Float {
//                        self?.toTextField.text = formatter
//                            .string(from: NSNumber(value: conversionRate * fromValue))
//                    }
                    TopStories.topStories = dict
                    print(dict)
                }
                }, onError: { [weak self] (error) in
                    print(error as NSError)
            })
            .addDisposableTo(disposeBag)
    }
}
