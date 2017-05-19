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

class TopStoriesController {
    
    let disposeBag = DisposeBag()
    let topStories = Observable.just(TopStories.topStoriesID)
    func getTopStories() {
        let sourceStringURL = hackerNewsUrls.baseURL + hackerNewsUrls.getTopStories
        RxAlamofire.requestJSON(.get, sourceStringURL)
            .debug()
            .subscribe(onNext: { (r, json) in
                if let dict = json as? [Int] {
//                    let valDict = dict["rates"] as! Dictionary<String, AnyObject>
//                    if let conversionRate = valDict["USD"] as? Float {
//                        self?.toTextField.text = formatter
//                            .string(from: NSNumber(value: conversionRate * fromValue))
//                    }
                    TopStories.topStoriesID = dict
                    print(TopStories.topStoriesID)
                }
                }, onError: { (error) in
                    print(error as NSError)
            })
            .addDisposableTo(disposeBag)
    }
    
    func getApi() -> Observable<AnyObject?> {
        return Observable.create{ observer in
            let sourceStringURL = hackerNewsUrls.baseURL + hackerNewsUrls.getTopStories
            let request = Alamofire.request(sourceStringURL).validate()
                .response(completionHandler:  { response in
                    if ((response.error) != nil) {
                        observer.on(.error(response.error!))
                    } else {
                        observer.on(.next(response.data as AnyObject))
                        observer.on(.completed)
                    }
                });
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

