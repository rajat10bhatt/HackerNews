//
//  CommentTableViewCell.swift
//  Hacker News
//
//  Created by Rajat Bhatt on 26/05/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var commentDetails: UILabel!
    
     static let identifier = "commentCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWithStory(story: Comment) {
        self.commentTitle.text = story.by
        self.commentDetails.text = story.text
//        if let decendants = story.descendants {
//            self.detailsLabel.text = "\(String(describing: (story.by)!))\n\(String(describing: (story.score)!)) points | by \(String(describing: (story.by)!))| \(time) hours | \(String(describing: decendants))comments"
//        } else {
//            self.detailsLabel.text = "\(String(describing: (story.by)!))\n\(String(describing: (story.score)!)) points | by \(String(describing: (story.by)!))| \(time) hours | \(String(describing: 0)) comments"
//        }
    }
}
