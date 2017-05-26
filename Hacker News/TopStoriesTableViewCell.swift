//
//  TopStoriesTableViewCell.swift
//  Hacker News
//
//  Created by Rajat Bhatt on 5/16/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class TopStoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var storiesTitleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    static let identifier = "topStories"
    //var story: Story!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWithStory(story: Story) {
        let time = secondsToHourInt(timeInSeconds: (story.time!))
        self.storiesTitleLabel.text = story.title
        //self.detailsLabel.text = "Hello"
        if let kids = story.kids {
            self.detailsLabel.text = "\(String(describing: (story.by)!))\n\(String(describing: (story.score)!)) points | by \(String(describing: (story.by)!))| \(time) hours | \(String(describing: kids.count))comments"
        } else {
            self.detailsLabel.text = "\(String(describing: (story.by)!))\n\(String(describing: (story.score)!)) points | by \(String(describing: (story.by)!))| \(time) hours | \(String(describing: 0)) comments"
        }
    }
    
    func secondsToHourInt(timeInSeconds: Int) -> Int {
        return Int(timeInSeconds/(60*60))
    }
}
