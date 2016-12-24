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

}

//This protocol will be implemented by the homeViewController in order to help
//other view controllers
protocol homeVCAidDelegate {
    func getUser() -> FIRUser?
}



extension UINavigationController {
    func getRoot() -> UIViewController {
        if let root = self.visibleViewController {
            return root
        }
        return self
    }
}
