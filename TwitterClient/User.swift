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
            
                let userData = defaults.object(forKey: "currentUser0") as? NSData
            
                if let userData = userData {
                    //let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    do{
                        let dictionary = try JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    }catch{
                        print("********** \(_currentUser)")
                    }
                    
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user{
                do{
                    //print(user.dictionary?.allKeys)
                    let data = try JSONSerialization.data(withJSONObject: user.dictionary!, options: JSONSerialization.WritingOptions(rawValue: UInt(0)))
                    
                    defaults.set(data, forKey: "currentUser0")
                } catch{
                    print("---------- \(_currentUser)")
                }
                
            }else {
                defaults.removeObject(forKey: "currentUser0")

            }
            
            defaults.synchronize()
        }
    }
    

}
