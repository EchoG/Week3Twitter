//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Chenran Gong on 10/30/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var user_phote: UIImageView!
    @IBOutlet weak var newTweetInfo: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var newTweetButton: UIBarButtonItem!
    
    var user: User?
    var tweet_id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.currentUser
        if user != nil{
            nameLabel.text = user?.name as String?
            user_phote.setImageWith((user?.profileUrl)! as URL)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func newTweet(_ sender: AnyObject) {
        print("******* \(newTweetInfo.text)")

        let tweetContent = newTweetInfo.text
        let client = TwitterClient.sharedInstance
        
        var params = Dictionary<String, Any>()
        params["status"] = tweetContent
        
        if tweet_id != nil {
            params["in_reply_to_status"] = tweet_id
        }
        
        client?.post("1.1/statuses/update.json", parameters: params, progress: { (progress: Progress) in
            print("in progress")
            }, success: { (task: URLSessionDataTask, response: Any?) in
                print("success")
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error)
        })
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
