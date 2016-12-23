//
//  AppDelegate.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/18/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public var authListener: FIRAuthStateDidChangeListenerHandle? = nil


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("before configure")
        FIRApp.configure()
        print("after configure")
        //addAuthListener()
        
        return true
    }
    
    
    public func addAuthListener() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        authListener = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            // ...
            if user != nil {
                print("In the state did change listener")
                print("Will instantiate HomeViewController")
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "NavHomeViewController")
            } else {
                print("In the state did change listener")
                print("Will instantiate LoginViewController")
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            }
        }
        
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            // ...
            print( "In the single checker")
            print("Will instantiate HomeViewController")
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "NavHomeViewController")
            
        } else {
            // No user is signed in.
            // ...
            print("In the single checker")
            print("Will instantiate LoginViewController")
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        }

    }
    
    public func removeAuthListener() {
        FIRAuth.auth()?.removeStateDidChangeListener(authListener!)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

