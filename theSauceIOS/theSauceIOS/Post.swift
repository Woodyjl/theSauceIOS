//
//  Post.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/19/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class Post: AnyObject {
    
    public var userProfilePicturePath: String?
    public let uId: String;
    public var userName: String?
    public var imagePath: String?
    public let date: String
    public let location: String
    public let caption: String
    public var name: String? //image Name
    private var postKey: String?
    private let image: Data?
//    public var debugDescription: String {
//        get {
//            var detail = ""
//            detail.appendingFormat("%s = %s", <#T##arguments: CVarArg...##CVarArg#>)
//        }
//    }
    
//    init() {
//    
//    }
    
    init(userId: String, dateTaken: String, location: String, caption: String, image: Data?) {
        uId = userId
        date = dateTaken
        self.location = location
        self.caption = caption
        self.image = image
    }
    
    convenience init(userId: String, dateTaken: String?, location: String?, caption: String?, userName: String, imagePath: String,
         userProfilePicturePath: String, imageName: String, postKey: String) {
        self.init(userId: userId, dateTaken: dateTaken == nil ? "" : dateTaken!, location: location == nil ? "" : location!,
                  caption: caption == nil ? "" : caption!, image: nil)
        self.userName = userName
        self.imagePath = imagePath
        self.userProfilePicturePath = userProfilePicturePath
        name = imageName
        self.postKey = postKey
    }

    
    
    public func uploadToCloud(resultDelegate: PostResultDelegate?) throws {
        if image != nil {
            let storage = FIRStorage.storage()
            // Create a root reference
            let postStorageRef = storage.reference().child("Post").child(uId).child(Int(Date().timeIntervalSince1970).description)
            
            _ = postStorageRef.put(image!, metadata: nil) { [refToSelf = self] (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    resultDelegate?.didUploadSuceed?(success: false, error: error)
                    return
                }
                resultDelegate?.didUploadSuceed?(success: true, error: error)
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL()?.absoluteString
                let imageName = metadata.name
                
                let databaseRef = FIRDatabase.database()
                let key = databaseRef.reference().child(refToSelf.uId).childByAutoId().key
                let postDatabaseRef = databaseRef.reference().child("Post").child(refToSelf.uId).child(key)
                
                postDatabaseRef.child("uId").setValue(refToSelf.uId)
                postDatabaseRef.child("date").setValue(refToSelf.date)
                postDatabaseRef.child("location").setValue(refToSelf.location)
                postDatabaseRef.child("caption").setValue(refToSelf.caption)
                postDatabaseRef.child("name").setValue(imageName)
                postDatabaseRef.child("postKey").setValue(key)
                postDatabaseRef.child("imagePath").setValue(downloadURL)
                
                let userDataRef = databaseRef.reference().child("userProfileInfo").child(refToSelf.uId)
                userDataRef.observeSingleEvent(of: .value, with: { snapshot in
                    
                    if let theData = snapshot.value as? NSDictionary  {
                        if let uname = theData["userName"] as? String {
                            postDatabaseRef.child("userName").setValue(uname)
                        }
                        if let pimage = theData["userProfilePicturePath"] as? String {
                            postDatabaseRef.child("userProfilePicturePath").setValue(pimage)
                        }
                    }
                })

            }

        } else {
            throw YourError(description: "post image is nil, cannot upload nil reference")
        }
    }
    
    public func deleteFromCloud(resultDelegate: PostResultDelegate?) {
        if name != nil && postKey != nil {
            let storage = FIRStorage.storage()
            // Create a root reference
            let postStorageRef = storage.reference().child("UserProfile").child(uId).child(name!)
            postStorageRef.delete(completion: { [unowned self] (error) in
                if let error = error {
                    resultDelegate?.didDeletionSuceed?(success: false, error: error)
                } else {
                    resultDelegate?.didDeletionSuceed?(success: true, error: error)
                    let databaseRef = FIRDatabase.database()
                    let postDatabaseRef = databaseRef.reference().child("Post").child(self.uId).child(self.postKey!)
                    postDatabaseRef.removeValue()
                }
            })
        } else {
            let error = YourError(description: "image name and/or postKey is nil");
            resultDelegate?.didDeletionSuceed?(success: false, error: error)
        }
        
    }
    
}

struct YourError: Error {
    var debugDescription: String
    init(description: String) {
        debugDescription = description
    }
}

@objc protocol PostResultDelegate {
    @objc optional func didUploadSuceed(success: Bool, error: Error?)
    @objc optional func didDeletionSuceed(success: Bool, error: Error?)
}
