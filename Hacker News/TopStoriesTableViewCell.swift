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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWithStory(story: Int) {
        self.storiesTitleLabel.text = String(describing: story)
//        let time = secondsToHourInt(timeInSeconds: story.time!)
//        self.storiesTitleLabel.text = story.title
//        self.detailsLabel.text = "\(story.by)\n\(story.score) points | by \(story.by)| \(time) hours | \(story.kids?.count)comments"
    }
    
    func secondsToHourInt(timeInSeconds: Int) -> Int {
        return Int(timeInSeconds/(60*60))
    }
}
