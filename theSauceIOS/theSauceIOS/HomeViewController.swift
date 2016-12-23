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
    
    var newsFeedCon: NewsFeedViewController? //= NewsFeedViewController()
    var profileCon: ProfileViewController? //= ProfileViewController()
    var previouslySelectedView: Int?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func getUser() -> FIRUser? {
        return fbUser
    }

}

//This protocol will be implemented by the homeViewController in order to help
//other view controllers
protocol homeVCAidDelegate {
    func getUser() -> FIRUser?
}
