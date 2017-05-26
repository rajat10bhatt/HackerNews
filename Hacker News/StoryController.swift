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
import ObjectMapper

class StoryController{
    let disposeBag = DisposeBag()
    func getStory(itemID: Int) -> Observable<AnyObject?> {
        let sourceStringURL = hackerNewsUrls.baseURL + hackerNewsUrls.getHackerNewsItem + String(describing: itemID) + hackerNewsUrls.getHackerNewsItemAddOn
        return Observable.create{ observer in
            let request = Alamofire.request(sourceStringURL).validate()
                .responseJSON(completionHandler:  { response in
//                    if ((response.error) != nil) {
//                        observer.on(.error(response.error!))
//                    } else {
//                        observer.on(.next(response as AnyObject))
//                        observer.on(.completed)
//                    }
                    switch response.result {
                    case .success(let json):
                        let story = Mapper<Story>().map(JSONObject: json)
                        observer.on(.next(story as AnyObject))
                        observer.on(.completed)
                    case .failure(let error):
                        observer.on(.error(error))
                    }
                });
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func getComment(itemID: Int) -> Observable<AnyObject?> {
        let sourceStringURL = hackerNewsUrls.baseURL + hackerNewsUrls.getHackerNewsItem + String(describing: itemID) + hackerNewsUrls.getHackerNewsItemAddOn
        return Observable.create{ observer in
            let request = Alamofire.request(sourceStringURL).validate()
                .responseJSON(completionHandler:  { response in
                    //                    if ((response.error) != nil) {
                    //                        observer.on(.error(response.error!))
                    //                    } else {
                    //                        observer.on(.next(response as AnyObject))
                    //                        observer.on(.completed)
                    //                    }
                    switch response.result {
                    case .success(let json):
                        let story = Mapper<Comment>().map(JSONObject: json)
                        observer.on(.next(story as AnyObject))
                        observer.on(.completed)
                    case .failure(let error):
                        observer.on(.error(error))
                    }
                });
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
