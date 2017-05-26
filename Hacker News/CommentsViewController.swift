//
//  CommentsViewController.swift
//  Hacker News
//
//  Created by Rajat Bhatt on 26/05/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit
import RxSwift

class CommentsViewController: UIViewController {
    var story: Story!
    var kidsID = [Int]()
    let disposeBag = DisposeBag()
    let storyController = StoryController()
    let kids: Variable<[Comment]> = Variable([])
    var commentObservable: Observable<[Comment]>!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let decendents = story.kids {
            print("\(String(describing: self.story.title))\n\(decendents)")
            self.kidsID = decendents
            getDecendentsData()
        } else {
            print("No decendents")
        }
    }
    
    func getDecendentsData() {
        var count = 0
        let _ = self.kidsID.map{ id in
            return self.storyController.getComment(itemID: id).subscribe(
                onNext: { story in
                    let story1 = story as! Comment
                    print(story1.by ?? "Story Id")
                    self.kids.value.append(story1)
                    count += 1
            }, onCompleted: {
                //print("completed")
                if count == self.kidsID.count {
                    DispatchQueue.main.async {
                        self.setupCommentTableView()
                    }
                }
            }).addDisposableTo(disposeBag)
        }
    }
    
    func setupCommentTableView() {
        commentObservable = Observable.just(kids.value)
        commentObservable
            .bindTo(commentTableView
                .rx
                .items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)){
                    row, story, cell in
                    print("\(String(describing: story.text))")
                    cell.configureWithStory(story: story)
            }.addDisposableTo(disposeBag)
    }
}
