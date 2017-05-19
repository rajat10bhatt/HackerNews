//
//  ViewController.swift
//  Hacker News
//
//  Created by Rajat Bhatt on 5/16/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TopStoriesViewController: UIViewController {

    @IBOutlet weak var topStoriesTableView: UITableView!
    
    let disposeBag = DisposeBag()
    let controller = TopStoriesController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getTopStories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    //MARK:- Rx Setup
    func getTopStories() {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        operationQueue.qualityOfService = QualityOfService.userInitiated
        let backgroundWorkScheduler
            = OperationQueueScheduler(operationQueue: operationQueue)
        controller.getApi()
            // Set 3 attempts to get response
            .retry(3)
            // Set 2 seconds timeout
            .timeout(20, scheduler: MainScheduler.instance)
            // Subscribe in background thread
            .subscribeOn(backgroundWorkScheduler)
            // Observe in main thread
            .observeOn(MainScheduler.instance)
            // Subscribe on observer
            .subscribe(
                onNext: { data in
                    do {
                        let post = try JSONSerialization.jsonObject(with: (data as! NSData) as Data, options: []) as! NSArray as! [Int]
                        print(post)
                    } catch  {
                        print(NSString(data: (data as! NSData) as Data, encoding: String.Encoding.utf8.rawValue) ?? "Hello")
                        return
                    }
            },
                onError: { error in
                    print(error)
            },
                onCompleted: {
                    print("Completed")
            },
                onDisposed: {
                    print("Disposed")
            }
            )
            .addDisposableTo(disposeBag)
    }
//    func setupCellConfiguration() {
//        //1
//        TopStoriesController.topStoriesSaredInstance.topStories
//            .bindTo(self.topStoriesTableView
//                .rx //2
//                .items(cellIdentifier: TopStoriesTableViewCell.identifier,
//                       cellType: TopStoriesTableViewCell.self)) { // 3
//                        row, story, cell in
//                        cell.configureWithStory(story: story) //4
//            }
//            .addDisposableTo(disposeBag)//5
//        TopStoriesController.topStoriesSaredInstance.topStories.asObservable().subscribe(onNext: { storyId in
//            print(storyId)
//        }).addDisposableTo(disposeBag)
//    }
    
//    private func setupCellTapHandling() {
//        topStoriesTableView
//            .rx
//            .modelSelected(Story.self) //1
//            .subscribe(onNext: { //2
//                chocolate in
//                ShoppingCart.sharedCart.chocolates.value.append(chocolate) //3
//                
//                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
//                    self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
//                } //4
//            })
//            .addDisposableTo(disposeBag) //5
//    }

}

