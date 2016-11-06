//
//  UserTweetCell.swift
//  TwitterClient
//
//  Created by Chenran Gong on 11/5/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit

class UserTweetCell: UITableViewCell {

    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tweetPhoto: UIImageView!
    
    var tweet: Tweet! {
        didSet{
            
            tweetContent.text = tweet.text as String?
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            timeStamp.text = dateFormatter.string(from: tweet.timestamp as! Date)
            let user = tweet.user
            name.text = user?.name as String?
            tweetPhoto.setImageWith((user?.profileUrl)! as URL)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
