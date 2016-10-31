//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Chenran Gong on 10/29/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newTweetButton: UIButton!
    @IBOutlet weak var tweetsTableView: UITableView!

    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tweetsTableView.dataSource = self
        self.tweetsTableView.delegate = self
        
        
        //tweetsTableView.rowHeight = UITableViewAutomaticDimension
        //tweetsTableView.estimatedRowHeight = 300
        
        TwitterClient.sharedInstance?.homeTimeline(success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            
        }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }

    @IBAction func newTweet(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "newTweet", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tweets != nil){
            return self.tweets.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = self.tweets[indexPath.row]
        //print("********* \(cell.tweet.text)")
        
        return cell
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeline(success: {(tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            refreshControl.endRefreshing()
            
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetDetail" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! TweetDetailViewController
            var indexPath = tweetsTableView.indexPath(for: sender as! UITableViewCell)
            var tweet = tweets[(indexPath?.row)!]
            vc.tweet = tweet
        }
        
    }

}
