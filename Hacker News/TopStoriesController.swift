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

