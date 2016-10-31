//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Chenran Gong on 10/29/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "vtAuBokvO9hSMytn781AzPXHh", consumerSecret: "Qc1L8NbN2duGTPdbkGeSTA0Uo1Ct5ygAz1IsRnsXDUFiTNnYaS")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth") as URL!, scope: nil, success: { (requestToken:BDBOAuth1Credential?) in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.openURL(url!)
            
            }, failure: { (error:Error?) in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error as! NSError)
        })
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.UserDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)

        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user:User) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) in
                    self.loginFailure?(error as NSError)
                })
            }, failure: { (error: Error?) in
                self.loginFailure?(error! as NSError)
                
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            //print(dictionaries)
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                failure(error as NSError)
        })
    
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            //print("account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
          
//            print("name: \(user.name)")
//            print("screenname: \(user.screenname)")
//            print("profile url: \(user.profileUrl)")
//            print("description: \(user.tagline)")
            
            }, failure: { (task:URLSessionDataTask?, error:Error) in
                failure(error as NSError)
                
        })
    }
    
    

}
