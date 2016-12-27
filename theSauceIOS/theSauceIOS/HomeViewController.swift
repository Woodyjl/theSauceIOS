//
//  HomeViewController.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/18/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UITabBarController, homeVCAidDelegate {
    
    
    lazy var fbUser: FIRUser? = {
        let lazilyRetrievedUser = FIRAuth.auth()?.currentUser
        return lazilyRetrievedUser
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navCon = self.viewControllers?[0] as? UINavigationController
        let destinationVC = navCon?.getRoot() as? NewsFeedViewController
        destinationVC?.helper = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print(segue.identifier)
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.tag)
        switch item.tag {
        case 0:
            let navCon = self.viewControllers?[item.tag] as? UINavigationController
            let destinationVC = navCon?.getRoot() as? NewsFeedViewController
            destinationVC?.helper = self
            break
        case 1:
            let navCon = self.viewControllers?[item.tag] as? UINavigationController
            let destinationVC = navCon?.getRoot() as? ProfileViewController
            destinationVC?.helper = self
            break
        default:
            break
        }
    }
 
    
    func getUser() -> FIRUser? {
        return fbUser
    }
    
    func tabBarIs(hidden: Bool) {
        tabBar.isHidden = hidden
    }

}

//This protocol will be implemented by the homeViewController in order to help
//other view controllers
protocol homeVCAidDelegate {
    func getUser() -> FIRUser?
    
    func tabBarIs(hidden: Bool)
}



extension UINavigationController {
    func getRoot() -> UIViewController {
        if let root = self.visibleViewController {
            return root
        }
        return self
    }
}
