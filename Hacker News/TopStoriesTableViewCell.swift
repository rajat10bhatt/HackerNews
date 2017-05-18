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
    
    func configureWithStory(story: Story) {
        let time = minutesToHour(timeInseconds: story.time!)
        self.storiesTitleLabel.text = story.title
        self.detailsLabel.text = "\(story.by)\n\(story.score) points | by \(story.by)| \(time) hours | \(story.kids?.count)comments"
//        countryNameLabel.text = chocolate.countryName
//        emojiLabel.text = "🍫" + chocolate.countryFlagEmoji
//        priceLabel.text = CurrencyFormatter.dollarsFormatter.rw_string(from: chocolate.priceInDollars)


}
