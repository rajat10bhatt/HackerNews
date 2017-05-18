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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Rx Setup
    private func setupCellConfiguration() {
        //1
        TopStoriesController.topStoriesSaredInstance.topStories
            .bindTo(self.topStoriesTableView
                .rx //2
                .items(cellIdentifier: TopStoriesTableViewCell.identifier,
                       cellType: TopStoriesTableViewCell.self)) { // 3
                        row, story, cell in
                        cell.configureWithStory(chocolate: story) //4
            }
            .addDisposableTo(disposeBag) //5
    }
    
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

