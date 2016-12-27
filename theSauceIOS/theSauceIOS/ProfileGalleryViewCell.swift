//
//  ProfileGalleryViewCell.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/23/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit

class ProfileGalleryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
    var post: Post? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        // Resets any existing pst information
        postImageView?.image = nil
        
        // Loads new information from post if any
        
        if let post = self.post {
            DispatchQueue.global().async { [weak weakSelf = self] in
                var image: UIImage? = nil
                if (SharedData.alreadyFetchedPostPhotos[(post.name)!] != nil) {
                    image = UIImage(data: SharedData.alreadyFetchedPostPhotos[(post.name)!]!)
                } else {
                    let data = try? Data(contentsOf: URL.init(string: post.imagePath!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    if let theData = data {
                        SharedData.alreadyFetchedPostPhotos[(post.name)!] = theData
                        image = UIImage(data: theData)
                    }
                }
                
                DispatchQueue.main.async {
                    weakSelf?.postImageView?.image = image
                }
            }
        }
        
    }

    
}

class ProfileHeaderViewCell: UICollectionReusableView {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var userInfo: NSDictionary? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        profileImageView?.image = nil
        userName?.text = nil
        
        if let userInfo = self.userInfo {
            let uId = userInfo["uId"] as? String
            userName?.text = userInfo["userName"] as? String
            DispatchQueue.global().async { [weak weakSelf = self] in
                var image: UIImage? = nil
                if (SharedData.alreadyFetchedProfileImage[uId!] != nil) {
                    image = UIImage(data: SharedData.alreadyFetchedProfileImage[uId!]!)
                } else {
                    let data = try? Data(contentsOf: URL.init(string: (userInfo["userProfilePicturePath"] as? String)!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    if let theData = data {
                        SharedData.alreadyFetchedProfileImage[uId!] = theData
                        image = UIImage(data: theData)
                    }
                }
                
                DispatchQueue.main.async {
                    weakSelf?.profileImageView?.image = image
                }
            }
        }
    }
}
