//
//  ProfileViewController.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/19/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileViewController: UICollectionViewController {
    
    var arrayOflistOfPosts = [Array<Post>]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var userInfo = NSDictionary() {
        didSet {
            fetchlatestPost()
        }
    }
    
    var helper: homeVCAidDelegate?
    
    
    func logout() {
        //        let firebaseAuth = FIRAuth.auth()
        //        do {
        //            try firebaseAuth?.signOut()
        //        } catch let signOutError as NSError {
        //            print ("Error signing out: %@", signOutError)
        //        }
        print("works")
    }
    
    //let helperVC: homeVCAidDelegate
    
//    init() {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 100, height: 100)
//        super.init(collectionViewLayout: layout)
//        //delegate: homeVCAidDelegate
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        //fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes navigationController?.
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ProfileViewController.logout))
        self.navigationItem.rightBarButtonItem = logoutButton
        
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        
        if let helper = self.helper {
            let databaseRef = FIRDatabase.database()
            
            let postRef = databaseRef.reference().child("userProfileInfo").child((helper.getUser())!.uid)
            
            postRef.observeSingleEvent(of: .value, with: { [unowned UOSelf = self] (snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    print(data.debugDescription)
                    
                    UOSelf.userInfo = data
                }
            })
        }

    }
    
    private func fetchlatestPost() {
        
        if let helper = self.helper {
            let databaseRef = FIRDatabase.database()
            
            let postRef = databaseRef.reference().child("Post").child((helper.getUser())!.uid)
            
            if arrayOflistOfPosts.isEmpty {
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
                        return p1.name! < p2.name!
                    })
                    
                    print(list.debugDescription)
                    
                    weakSelf?.arrayOflistOfPosts.insert(list, at: 0)
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
                        return p1.name! < p2.name!
                    })
                    
                    print(list.debugDescription)
                    
                    weakSelf?.arrayOflistOfPosts.insert(list, at: 0)
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
        // #warning Incomplete implementation, return the number of sections
        return arrayOflistOfPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        
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
        // #warning Incomplete implementation, return the number of items
        return arrayOflistOfPosts[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileGalleryPostCell", for: indexPath) as? ProfileGalleryViewCell
    
        // Configure the cell
        
        cell?.post = arrayOflistOfPosts[indexPath.section][indexPath.row]
    
        return cell!
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

}
