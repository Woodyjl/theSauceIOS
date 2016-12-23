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
        
        // Loads new information from post if any
        
        if let post = self.post {
            caption?.text = post.caption
            postDate?.text = post.date
            postLocation?.text = post.location
            userName?.text = post.userName
            DispatchQueue.global().async { [weak weakSelf = self] in
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: URL.init(string: post.imagePath!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        weakSelf?.postImage?.image = UIImage(data: data!)
                    }
                    
                }
                let data = try? Data(contentsOf: URL.init(string: post.userProfilePicturePath!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    weakSelf?.profileImage?.image = UIImage(data: data!)
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
