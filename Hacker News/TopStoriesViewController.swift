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
import RxPager

// MARK: Helper

private let startLoadingOffset: CGFloat = 20.0
private func isNearTheBottomEdge(_ contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
    return contentOffset.y +
        tableView.frame.size.height +
        startLoadingOffset > tableView.contentSize.height
}

class TopStoriesViewController: UIViewController {
    
    @IBOutlet private var topStoriesTableView: UITableView!
    
    let disposeBag = DisposeBag()
    let controller = TopStoriesController()
    let storyController = StoryController()
    var dummyStories = [Story]()
    let stories: Variable<[Story]> = Variable([])
    var topStoryIDs = [Int]()
    var topSoriesIDsForPaging = [Int]()
    var storyObservable: Observable<[Story]>!
    var page = 0
    let storiesPerPage = 10
    var startIndex = 0
    var endIndex = 0
    var tableViewDidReachBottom = true
    var tableViewDidSetup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTopStories()
        self.setupCellTapHandling()
        
    }
    
    func enumeratedmap() {
        if self.tableViewDidReachBottom {
            self.startIndex = self.page * self.storiesPerPage
            self.endIndex = self.startIndex + self.storiesPerPage
            self.topSoriesIDsForPaging.removeAll()
            for (index, id) in self.topStoryIDs.enumerated() {
                if index == endIndex {
                    break
                }
                if index >= startIndex {
                    self.topSoriesIDsForPaging.append(id)
                }
            }
            page += 1
            print(self.topSoriesIDsForPaging)
            //self.stories.value.removeAll()
            self.getStoryData()
            self.tableViewDidReachBottom = false
        }
    }
    
    //MARK: TableView Scroll delegate
    func detectTableViewScroll() {
        // dismiss keyboard on scroll
        self.topStoriesTableView.rx.contentOffset
            .subscribe { offset in
                //print("Offset:- \(String(describing: offset.element?.y))")
                //print("TableView ContentSize:- \(self.topStoriesTableView.contentSize.height)")
                if ((offset.element?.y)! + self.topStoriesTableView.frame.size.height +
                    startLoadingOffset) > self.topStoriesTableView.contentSize.height {
                    self.enumeratedmap()
                }
            }
            .addDisposableTo(disposeBag)
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
                    //self.getStoryData()
                    //self.enumeratedmap()
                    self.detectTableViewScroll()
            },
                onDisposed: {
                    print("Disposed")
            }
            )
            .addDisposableTo(disposeBag)
    }
    
    func getStoryData() {
        var count = 0
        let _ = self.topSoriesIDsForPaging.map{ id in
            return self.storyController.getStory(itemID: id).subscribe(
                onNext: { story in
                    let story1 = story as! Story
                    //print(story1.by ?? "Story Id")
                    self.stories.value                       .append(story1)
                    count += 1
            }, onCompleted: {
                //print("completed")
                if count == self.topSoriesIDsForPaging.count {
                    DispatchQueue.main.async {
                        //self.stories.value = self.dummyStories
                        self.setupTableView()
                        self.tableViewDidReachBottom = true
                    }
                }
            }).addDisposableTo(disposeBag)
        }
    }
    
    func setupTableView() {
        self.topStoriesTableView.dataSource = nil
        self.stories.asObservable()
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
                print(story.id)
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
