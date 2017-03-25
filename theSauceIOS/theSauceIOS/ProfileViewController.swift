//
//  ProfileViewController.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/19/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UICollectionViewController, PostResultDelegate {
    
    var listOfPosts = Array<Post>() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var recentlyDeleted: Post?
    
    var userInfo: NSMutableDictionary? {
        didSet {
            fetchlatestPost()
        }
    }
    
    var helper: homeVCAidDelegate?
    
    
    func logout() {
                let firebaseAuth = FIRAuth.auth()
                do {
                    try firebaseAuth?.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes navigationController?.
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ProfileViewController.logout))
        self.navigationItem.rightBarButtonItem = logoutButton
        
        let refreshButton = UIBarButtonItem(title: "refresh", style: .plain, target: self, action: #selector(self.fetchlatestPost))
        self.navigationItem.leftBarButtonItem = refreshButton
        
        fetchUserInfo()
        
        let tabBarFrame = tabBarController!.tabBar.frame
        let frame = CGRect(x: tabBarFrame.minX + 30, y: tabBarFrame.minY
            - tabBarFrame.height, width: tabBarFrame.width - (2 * 30), height: tabBarFrame.height - 10)
        
        let message = SharedData.notificationBubble(text: "Hey there!!!", with: frame)
        message.alpha = 0
        //tabBarController?.view.addSubview(message)
        navigationController!.view.addSubview(message)
        UIView.animate(withDuration: 0.9, animations: {
            message.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                UIView.animate(withDuration: 0.9, animations: {
                    message.alpha = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { 
                        message.removeFromSuperview()
                    })
                })
            })
        })
    }

    private func fetchUserInfo() {
        
        if let helper = self.helper {
            let databaseRef = FIRDatabase.database()
            
            let postRef = databaseRef.reference().child("userProfileInfo").child((helper.getUser())!.uid)
            
            postRef.observeSingleEvent(of: .value, with: { [unowned UOSelf = self] (snapshot) in
                if let data = snapshot.value as? NSMutableDictionary {
                    print(data.debugDescription)
                    data["uId"] = UOSelf.helper?.getUser()?.uid
                    print(data.debugDescription)
                    UOSelf.userInfo = data
                }
            })
        }

    }
    
    //"8dKIKjbLBRXur7cHaAVBtja2Dd32")
    @objc private func fetchlatestPost() {
        
        if let helper = self.helper {
            let databaseRef = FIRDatabase.database()
            
            let postRef = databaseRef.reference().child("Post").child((helper.getUser())!.uid)
            
            if listOfPosts.isEmpty {
                postRef.observeSingleEvent(of: .value, with: { [weak weakSelf = self] (snapshot) in
                    var list = Array<Post>()
                    let enumerator = snapshot.children
                    while let userPosts = enumerator.nextObject() as? FIRDataSnapshot {
                        //print(posts.key)
                        //print(posts.value)
                        if let aPost = userPosts.value as? NSDictionary {
                            let userProfilePicturePath = aPost["userProfilePicturePath"] as? String
                            let uId = aPost["uId"] as? String
                            let userName = aPost["userName"] as? String
                            let imagePath = aPost["imagePath"] as? String
                            let date = aPost["date"] as? String
                            let location = aPost["location"] as? String
                            let caption = aPost["caption"] as? String
                            let name = aPost["name"] as? String
                            let postKey = aPost["postKey"] as? String
                            
                            print(aPost.debugDescription)
                            let post = Post(userId: uId!, dateTaken: date, location: location,
                                            caption: caption, userName: userName!,
                                            imagePath: imagePath!, userProfilePicturePath: userProfilePicturePath!,
                                            imageName: name!, postKey: postKey!)
                            list.append(post)
                        }
                        
                    }
                    list.sort(by: { (p1: Post, p2: Post) -> Bool in
                        return p1.name! > p2.name!
                    })
                    
                    print(list.debugDescription)
                    
                    weakSelf?.listOfPosts.append(contentsOf: list)  //insert(list, at: 0)
                    })

            } else {
                
                
                // Listen for new user posts in the Firebase database
                postRef.observe(.childAdded, with: { [weak weakSelf = self] (snapshot) -> Void in
                    var list = Array<Post>()
                    let enumerator = snapshot.children
                    while let userPosts = enumerator.nextObject() as? FIRDataSnapshot {
                        //print(posts.key)
                        //print(posts.value)
                        if let aPost = userPosts.value as? NSDictionary {
                            let userProfilePicturePath = aPost["userProfilePicturePath"] as? String
                            let uId = aPost["uId"] as? String
                            let userName = aPost["userName"] as? String
                            let imagePath = aPost["imagePath"] as? String
                            let date = aPost["date"] as? String
                            let location = aPost["location"] as? String
                            let caption = aPost["caption"] as? String
                            let name = aPost["name"] as? String
                            let postKey = aPost["postKey"] as? String
                            
                            print(aPost.debugDescription)
                            let post = Post(userId: uId!, dateTaken: date, location: location,
                                            caption: caption, userName: userName!,
                                            imagePath: imagePath!, userProfilePicturePath: userProfilePicturePath!,
                                            imageName: name!, postKey: postKey!)
                            list.append(post)
                        }
                        
                    }
                    list.sort(by: { (p1: Post, p2: Post) -> Bool in
                        return p1.name! > p2.name!
                    })
                    
                    print(list.debugDescription)
                    while !list.isEmpty {
                        weakSelf?.listOfPosts.insert(list.popLast()!, at: 0)
                    }
                })
            }
        }
    }
    
    //var counter = 0

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        
        case UICollectionElementKindSectionFooter:
            fallthrough
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ProfileHeaderCell",
                                                                             for: indexPath) as? ProfileHeaderViewCell
            headerView?.userInfo = userInfo
            return headerView!
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(listOfPosts.count)
        return self.listOfPosts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileGalleryPostCell", for: indexPath) as? ProfileGalleryViewCell
    
        // Configure the cell
        
        cell?.post = listOfPosts[indexPath.row]
    
        let deletionGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.deletePost(_:)))
        cell?.addGestureRecognizer(deletionGesture)
        return cell!
    }
    
    public func deletePost(_ sender: UILongPressGestureRecognizer) {
        let pointInView = sender.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: pointInView) {
            print(listOfPosts.count)
            print(collectionView?.numberOfItems(inSection: indexPath.section))
            recentlyDeleted = listOfPosts.remove(at: indexPath.row) as Post
            print(listOfPosts.count)
            print(collectionView?.numberOfItems(inSection: indexPath.section))
            
            //collectionView?.deleteItems(at: [indexPath])

            recentlyDeleted!.deleteFromCloud(resultDelegate: self, with: indexPath)
            print(listOfPosts.count)
        }
    }
    
    func didDeletionSuceed(success: Bool, error: Error?, info: Any?) {
        if !success {
            if let indexPath = info as? IndexPath {
                let tabBarFrame = tabBarController!.tabBar.frame
                let frame = CGRect(x: tabBarFrame.minX + 30, y: tabBarFrame.minY
                    - tabBarFrame.height, width: tabBarFrame.width - (2 * 30), height: tabBarFrame.height - 10)
                
                let message = SharedData.notificationBubble(text: "Deletion fail", with: frame)
                message.alpha = 0
                //tabBarController?.view.addSubview(message)
                navigationController!.view.addSubview(message)
                UIView.animate(withDuration: 0.9, animations: {
                    message.alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                        UIView.animate(withDuration: 0.9, animations: {
                            message.alpha = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                message.removeFromSuperview()
                            })
                        })
                    })
                })
                
                print(error?.localizedDescription)
                
            listOfPosts.insert(recentlyDeleted!, at: indexPath.row)
            }
        } else {
            
        }
    }
    
}
