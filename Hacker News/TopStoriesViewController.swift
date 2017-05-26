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
    
    @IBOutlet private var topStoriesTableView: UITableView!
    
    let disposeBag = DisposeBag()
    let controller = TopStoriesController()
    let storyController = StoryController()
    let stories: Variable<[Story]> = Variable([])
    var topStoryIDs = [Int]()
    var storyObservable: Observable<[Story]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.topStoriesTableView.dataSource = self
        //        self.topStoriesTableView.delegate = self
        getTopStories()
        self.setupCellTapHandling()
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
                        self.topStoryIDs = post
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
                    self.getStoryData()
            },
                onDisposed: {
                    print("Disposed")
            }
            )
            .addDisposableTo(disposeBag)
    }
    
    func getStoryData() {
        var count = 0
        let _ = self.topStoryIDs.map{ id in
            return self.storyController.getStory(itemID: id).subscribe(
                onNext: { story in
                    let story1 = story as! Story
                    //print(story1.by ?? "Story Id")
                    self.stories.value.append(story1)
                    count += 1
            }, onCompleted: {
                //print("completed")
                if count == self.topStoryIDs.count {
                    DispatchQueue.main.async {
                        self.setupTableView()
                        //self.topStoriesTableView.reloadData()
                    }
                }
            }).addDisposableTo(disposeBag)
        }
    }
    
    func setupTableView() {
        storyObservable = Observable.just(stories.value)
        storyObservable
            .bindTo(topStoriesTableView
                .rx
                .items(cellIdentifier: TopStoriesTableViewCell.identifier, cellType: TopStoriesTableViewCell.self)){
            row, story, cell in
            cell.configureWithStory(story: story)
            }.addDisposableTo(disposeBag)
        
    }
    
    private func setupCellTapHandling() {
        topStoriesTableView
            .rx
            .modelSelected(Story.self) //1
            .subscribe(onNext: { //2
                story in
                self.performSegue(withIdentifier: SegueIdentifier.toComments.rawValue, sender: story)
                if let selectedRowIndexPath = self.topStoriesTableView.indexPathForSelectedRow {
                    self.topStoriesTableView.deselectRow(at: selectedRowIndexPath, animated: true)
                } //4
            })
            .addDisposableTo(disposeBag) //5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toComments.rawValue {
            if let story = sender as? Story {
                let destination = segue.destination as! CommentsViewController
                destination.story = story
            }
        }
    }
}
extension TopStoriesViewController: SegueHandler {
    enum SegueIdentifier: String {
        case toComments
    }
}
