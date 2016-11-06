//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Chenran Gong on 10/30/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var homeButton: UIBarButtonItem!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var user_photo: UIImageView!
    @IBOutlet weak var retweetNumber: UILabel!
    @IBOutlet weak var favoritesNumber: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tweet != nil {
            descriptionLabel.text = tweet?.text as String?
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            timeLabel.text = dateFormatter.string(from: tweet?.timestamp as! Date)
            let user = tweet?.user
            nameLabel.text = user?.name as String?
            user_photo.setImageWith((user?.profileUrl)! as URL)
            
            if(tweet?.retweetCount != nil){
                let number : Int = (tweet?.retweetCount)!
                //print(number)
                retweetNumber.text = "\(number)"
            }
            if(tweet?.favoritesCount != nil){
                let favoriteNumber = (tweet?.favoritesCount)!
                favoritesNumber.text = "\(favoriteNumber)"
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackHome(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction func replyTweet(_ sender: UIButton) {
        print("********* reply")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reply" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! NewTweetViewController
            vc.tweet_id = tweet?.tweet_id as String?
        }
        
    }
    
    @IBAction func retweet(_ sender: UIButton) {
        let client = TwitterClient.sharedInstance
        var params = Dictionary<String, Any>()
        
        var url = "1.1/statuses/retweet/\((tweet?.tweet_id)!).json"
        //print(tweet?.tweet_id)
        client?.post(url, parameters: params, progress: { (progress: Progress) in
            print("in progress")
            }, success: { (task: URLSessionDataTask, response: Any?) in
                print("success")
                
                let alertController =  UIAlertController(title: "Retweet", message: "Retweet is successful", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
                    //
                })
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error)
        })
    }
    
    @IBAction func favoriteTweet(_ sender: UIButton) {
        let client = TwitterClient.sharedInstance
        var params = Dictionary<String, Any>()
        var url = "1.1/favorites/create.json?id=\((tweet?.tweet_id)!)"
        //print(tweet?.tweet_id)
        client?.post(url, parameters: params, progress: { (progress: Progress) in
            print("in progress")
            }, success: { (task: URLSessionDataTask, response: Any?) in
                print("success")
                
                let alertController =  UIAlertController(title: "Favorite", message: "Already marked as favorite", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
                    //
                })
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error)
        })    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
