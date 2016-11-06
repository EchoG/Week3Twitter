//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Chenran Gong on 11/4/16.
//  Copyright © 2016 Chenran Gong. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    
    private var profileNavigationController: UIViewController!
    private var timelineNavigationController: UIViewController!
    private var mentionNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburghViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        //self.tableView.rowHeight = 100
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "profileNavigationViewController")
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(timelineNavigationController)
        
        hamburghViewController.contentViewController = timelineNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
        let titles = ["Profile", "Timeline", "Mention"]
        //print(titles[0])
        
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburghViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185.0
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
