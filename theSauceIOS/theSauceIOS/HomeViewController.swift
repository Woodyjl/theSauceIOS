//
//  HomeViewController.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/18/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UITabBarDelegate {
    
    
    lazy var fbUser: FIRUser? = {
        let lazilyRetrievedUser = FIRAuth.auth()?.currentUser
        return lazilyRetrievedUser
    }()
    
    @IBOutlet weak var tabBar: UITabBar!
    
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    let newsFeedCon = NewsFeedViewController()
    let profileCon = ProfileViewController()
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("TabBar tag: \(item.tag)")
        switch item.tag {
        case 0:
            self.view.insertSubview(newsFeedCon.tableView, belowSubview: self.tabBar)
            break
        case 1:
            self.view.insertSubview(profileCon.view, belowSubview: self.tabBar)
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        let firstTabBarItem = (tabBar.items?[0])!
        tabBar.selectedItem = firstTabBarItem
        tabBar(tabBar, didSelect: firstTabBarItem)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
