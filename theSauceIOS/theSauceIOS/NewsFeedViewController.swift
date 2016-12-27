//
//  NewsFeedViewController.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/18/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class NewsFeedViewController: UITableViewController {
    
    var arrayOfListOfPost = [Array<Post>]() {
        didSet {
            // Should not reload the data all the time inefficient
            self.tableView.reloadData()
        }
    }
    
//    var listOfPost = Array<Post>() {
//        didSet {
//            self.tableView.reloadData()
//        }
//    }
    
    var helper: homeVCAidDelegate?
    
    init() {
        //super.init(coder: NSCoder())!
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(NewsFeedViewController.createNewPost(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.left
        tableView.addGestureRecognizer(swipeGesture)
        updateFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        helper?.tabBarIs(hidden: false)
    }
    
    public func createNewPost(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("swiped")
            performSegue(withIdentifier: "ToCreatePost", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ToCreatePost":
                helper?.tabBarIs(hidden: true)
                if let destinationVC = segue.destination as? PostCreatorController {
                    destinationVC.userId = helper?.getUser()?.uid
                }
                break
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func updateFeed() {
        
        let databaseRef = FIRDatabase.database()
        
        let postRef = databaseRef.reference().child("Post")
        
        if (arrayOfListOfPost.isEmpty) {
            postRef.observeSingleEvent(of: .value, with: { [weak weakSelf = self] (snapshot) in
                var list = Array<Post>()
                let enumerator = snapshot.children
                while let userPosts = enumerator.nextObject() as? FIRDataSnapshot {
                    let secondEnumerator = userPosts.children
                    while let posts = secondEnumerator.nextObject() as? FIRDataSnapshot {
                        if let aPost = posts.value as? NSDictionary {
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
                    
                }
                list.sort(by: { (p1: Post, p2: Post) -> Bool in
                    return p1.name! > p2.name!
                })
                
                print(list.debugDescription)
                for q in list {
                    print(q.name)
                }
                
                weakSelf?.arrayOfListOfPost.insert(list, at: 0)
                //weakSelf?.listOfPost.append(contentsOf: list)
                })

        } else {
            postRef.observe(.childAdded, with: { [weak weakSelf = self] (snapshot) in
                var list = Array<Post>()
                let enumerator = snapshot.children
                while let userPosts = enumerator.nextObject() as? FIRDataSnapshot {
                    let secondEnumerator = userPosts.children
                    while let posts = secondEnumerator.nextObject() as? FIRDataSnapshot {
                        if let aPost = posts.value as? NSDictionary {
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
                    
                }
                list.sort(by: { (p1: Post, p2: Post) -> Bool in
                    return p1.name! > p2.name!
                })
                
                print(list.debugDescription)
                for q in list {
                    print(q.name)
                }
                
                weakSelf?.arrayOfListOfPost.insert(list, at: 0)
                //weakSelf?.listOfPost.append(contentsOf: list)
                })

        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return arrayOfListOfPost.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfListOfPost[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var nib = UINib(nibName: "NewsFeedPostCell", bundle: nil)
        // do not use if you created a prototype in the storyboard
        //tableView.register(NewsFeedPostCell.self, forCellReuseIdentifier: "NewsFeedPostCell")

        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedPostCell", for: indexPath) as? NewsFeedPostCell

        // Configure the cell...
        //if let cell = cell as? NewsFeedPostCell {
        let post = arrayOfListOfPost[indexPath.section][indexPath.row]
        cell?.post = post
            
        //}
        return cell!
    }
 

  

   

}
