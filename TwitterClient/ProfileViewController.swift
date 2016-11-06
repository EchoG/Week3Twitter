//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Chenran Gong on 11/5/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var homeButton: UIBarButtonItem!

    @IBOutlet weak var userInfoView: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if user == nil {
            user = User.currentUser
        }
        userImage.setImageWith((user?.profileUrl)! as URL)
        nameLabel.text = user?.name as String?
        tweetsLabel.text = "\((user?.tweetsNumber)!)"
        followingLabel.text = "\((user?.followingNumber)!)"
        followersLabel.text = "\((user?.followersNumber)!)"
        
        let client = TwitterClient.sharedInstance
        
        var params = Dictionary<String, Any>()
        //params["screen_name"] = user?.screenname
        params["user_id"] = user?.id_str
        
        var url = "1.1/statuses/user_timeline.json?screen_name=\((user?.screenname)!)"
        client?.get(url, parameters: nil, progress: { (progress: Progress) in
            print("in progress")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("success")
            let dictionaries = response as! [NSDictionary]
            self.tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            self.tableView.reloadData()
            //success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tweets != nil){
            return self.tweets.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTweetCell", for: indexPath) as! UserTweetCell
        
        cell.tweet = self.tweets[indexPath.row]
        //print("********* \(cell.tweet.text)")
        
        return cell
    }
    

    @IBAction func goBackHome(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
