//
//  NewsFeedPostCell.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/21/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit

class NewsFeedPostCell: UITableViewCell {
    
    
    @IBOutlet weak var postLocation: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    
    @IBOutlet weak var loadview: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var profileLoadView: UIView!

    var previouslyRequestedPostImage: String?
    var previouslyRequestedProfileImage: String?
    
    var post: Post? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        // Resets any existing pst information
    
        caption?.text = nil
        postDate?.text = nil
        postLocation?.text = nil
        userName?.text = nil
        profileImage?.image = nil
        postImage?.image = nil
        loadview?.isHidden = false
        profileLoadView?.isHidden = false
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            loadview?.backgroundColor = UIColor.lightGray
            profileLoadView?.backgroundColor = UIColor.lightGray
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = loadview.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            loadview?.addSubview(blurEffectView)
            //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            loadview?.backgroundColor = UIColor.lightGray
            profileLoadView?.backgroundColor = UIColor.lightGray
        }
        
        // Loads new information from post if any
        
        if let post = self.post {
            caption?.text = post.caption
            postDate?.text = post.date
            postLocation?.text = post.location
            userName?.text = post.userName
            previouslyRequestedPostImage = post.name
            previouslyRequestedProfileImage = post.uId
            spinner.startAnimating()
            print("Fetching image \(post.name)")
            print("imageView set to \(postImage.image)")
            DispatchQueue.global().async { [weak weakSelf = self] in
                DispatchQueue.global().async {
                    var image: UIImage? = nil
                    if (SharedData.alreadyFetchedPostPhotos[(post.name)!] != nil) {
                        image = UIImage(data: SharedData.alreadyFetchedPostPhotos[(post.name)!]!)
                        print("Fetched from dictionary \(image)")
                    } else {
                        let data = try? Data(contentsOf: URL.init(string: post.imagePath!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        if let theData = data {
                            SharedData.alreadyFetchedPostPhotos[(post.name)!] = theData
                            image = UIImage(data: theData)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        weakSelf?.loadview.isHidden = true
                        weakSelf?.spinner.stopAnimating()
                        if weakSelf?.previouslyRequestedPostImage == post.name {
                            print(image)
                            weakSelf?.postImage?.image = image
                        }
                    }
                    
                }
                var image: UIImage? = nil
                if (SharedData.alreadyFetchedProfileImage[(post.uId)] != nil) {
                    image = UIImage(data: SharedData.alreadyFetchedProfileImage[(post.uId)]!)
                } else {
                    let data = try? Data(contentsOf: URL.init(string: post.userProfilePicturePath!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    if let theData = data {
                        SharedData.alreadyFetchedProfileImage[(post.uId)] = theData
                        image = UIImage(data: theData)
                    }
                }
                
                DispatchQueue.main.async {
                    weakSelf?.profileLoadView?.isHidden = true
                    if weakSelf?.previouslyRequestedProfileImage == post.uId {
                        weakSelf?.profileImage?.image = image
                    }
                    
                }
            }
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
