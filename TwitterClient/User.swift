//
//  User.swift
//  TwitterClient
//
//  Created by Chenran Gong on 10/29/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit

class User: NSObject {
    static let UserDidLogoutNotification = "UserDidLogout"
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String as NSString?
        screenname = dictionary["screen_name"] as? String as NSString?
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
        }
        tagline = dictionary["description"] as? String as NSString?
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
            
                let userData = defaults.object(forKey: "currentUser") as? NSData
            
                if let userData = userData {
                   
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user{
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary as Any, options: [])
                defaults.set(data, forKey: "currentUser")
            }else {
                defaults.removeObject(forKey: "currentUserKey")

            }
            
            defaults.synchronize()
        }
    }
    

}
