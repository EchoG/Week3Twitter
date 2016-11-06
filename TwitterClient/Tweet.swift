//
//  Tweet.swift
//  TwitterClient
//
//  Created by Chenran Gong on 10/29/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var tweet_id: NSString?
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String as NSString?
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        tweet_id = dictionary["id_str"] as? String as NSString?
        
        let timestampString = dictionary["created_at"] as? String
        //print(timestampString)
        
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
            
        }
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
