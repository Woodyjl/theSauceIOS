//
//  SignUpViewController.swift
//  ChubbyHubbyPractice
//
//  Created by Woody Jean-Louis on 11/1/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class fSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var email1: UITextField!
    @IBOutlet weak var email2: UITextField!
    private var checkedPW: Password? = nil
    private var checkedEM: Email? = nil
    @IBOutlet weak var passWordSpinner: UIActivityIndicatorView!
    @IBOutlet weak var emailSpinner: UIActivityIndicatorView!
    

    @IBAction func password1DidEnd(_ sender: UITextField) {
        print("-----------------------------------------------")
        if passWordSpinner != nil {
            passWordSpinner.startAnimating()
            let queue = OperationQueue()
            
            queue.addOperation() { [unowned self] in
                // do something in the background
                self.checkedPW = Password(passWord: self.password1.text)
                print("----------------Before ending animation--------------------")
                print(self.passWordSpinner.isAnimating)
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    self.passWordSpinner.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func emailDidEnd(_ sender: UITextField) {
        if emailSpinner != nil {
            emailSpinner.startAnimating()
            let queue = OperationQueue()
            
            queue.addOperation() { [unowned self] in
                // do something in the background
                self.checkedEM = Email(email: self.email1.text)
                print("---------------------------------------------------")
                OperationQueue.main.addOperation() {
                    // when done, update your UI and/or model on the main queue
                    self.emailSpinner.stopAnimating()
                }
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func registerNewUser(_ sender: UIButton) {
        
        switch formIsCorrect() {
        case StateForSignUp.INCORRECT_USERNAME:
            presentAlert(title: AlertMessages.alertTitle, message: AlertMessages.alertMessageForIncorrectUserName)
            break
        case StateForSignUp.INCORRECT_PASSWORD1:
            presentAlert(title: AlertMessages.alertTitle, message: AlertMessages.alertMessageforIncorrectPassword1)
            break
        case StateForSignUp.INCORRECT_PASSWORD2:
            presentAlert(title: AlertMessages.alertTitle, message: AlertMessages.alertMessageForIncorrectPassword2)
            break
        case StateForSignUp.INCORRECT_EMAIL1:
            presentAlert(title: AlertMessages.alertTitle, message: AlertMessages.alertMessageForIncorrectEmail1)
            break
        case StateForSignUp.INCORRECT_EMAIL2:
            presentAlert(title: AlertMessages.alertTitle, message: AlertMessages.alertMessageForIncorrectEmail2)
            break
        case StateForSignUp.CORRECT:
            createNewUser();
            break
        }
    }
    
    
    private func createNewUser() {
        
        let firebaseAuth = FIRAuth.auth()
        (UIApplication.shared.delegate as! AppDelegate).removeAuthListener()
        
        firebaseAuth?.createUser(withEmail: email2.text!, password: password2.text!, completion: { [unowned self] (user: FIRUser?, error: Error?)   in
            
            if user != nil {
                
                let ref = FIRDatabase.database().reference()
                ref.child("userProfileInfo").child(user!.uid).child("userName").setValue(self.username.text!)
                
                OperationQueue.main.addOperation {
                    
                    let alert = UIAlertController(title: "Profile image", message: "we need a profile image for you", preferredStyle: UIAlertControllerStyle.actionSheet)
                    
                    let action1 = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { [unowned self] (alert: UIAlertAction!) in
                        
                        var imagePicker = UIImagePickerController()
                        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                            
                            imagePicker.delegate = self
                            imagePicker.sourceType = .savedPhotosAlbum;
                            imagePicker.allowsEditing = false
                            
                            self.present(imagePicker, animated: true, completion: nil)
                        } else {
                            //Gallery not available
                        }
                    })
                    
                    let action2 = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { [unowned self] (alert: UIAlertAction!) in
                        
                        var imagePicker = UIImagePickerController()
                        if UIImagePickerController.isSourceTypeAvailable(.camera){
                            
                            imagePicker.delegate = self
                            imagePicker.sourceType = .camera;
                            imagePicker.allowsEditing = false
                            
                            self.present(imagePicker, animated: true, completion: nil)
                            
                        }else{
                            print("Camera not awailable")
                        }
                    })
                    
                    alert.addAction(action1)
                    alert.addAction(action2)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                print("Exception Happened")
                print(error?.localizedDescription)
            }
        })
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            let storageRef = FIRStorage.storage().reference().child("UserProfile").child(uid!).child(Int(Date().timeIntervalSince1970).description)
            
            var data = Data()
            
            data = UIImageJPEGRepresentation(image, 1.0)!
            // Upload the file to the path "images/rivers.jpg"
            _ = storageRef.put(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
                let databaseRef = FIRDatabase.database().reference()
                databaseRef.child("userProfileInfo").child(uid!).child("userProfilePicturePath").setValue(downloadURL()!.absoluteString)
                
                let app = UIApplication.shared.delegate as! AppDelegate
                app.addAuthListener()
            }

        } else{
            print("Something went wrong")
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //implement
        
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: AlertMessages.exitAlertOption, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Essentially this function checks if the entries in the form for a new account is correct.
    private func formIsCorrect() -> StateForSignUp {
        
        if username.text! == "" {
            return StateForSignUp.INCORRECT_USERNAME
        }
        if checkedPW == nil || !((checkedPW?.correct)!) {
            return StateForSignUp.INCORRECT_PASSWORD1
        }
        if password2.text! != password1.text! {
            return StateForSignUp.INCORRECT_PASSWORD2
        }
        if checkedEM == nil || !((checkedEM?.correct)!) {
            return StateForSignUp.INCORRECT_EMAIL1
        }
        if email2.text! != email1.text! {
            return StateForSignUp.INCORRECT_EMAIL2
        }
        return StateForSignUp.CORRECT
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier) {
            case "goBack":
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    private struct Password {
        var passwd: String?  = nil
        var correct = false
        
        init(passWord info: String?) {
            self.passwd = info
            check()
        }
        
        private mutating func check() {
            if passwd != nil && passwd!.characters.count < 30 {
                //implement check if password contains speacial characters and normal characters.
                if passwd!.characters.count > 7 {
                    correct = true
                }
                
            }
        }
    }
    
    private struct Email {
        var email: String? = nil
        var correct = false
        
        init(email info: String?) {
            self.email = info
            check()
        }
        
        private mutating func check() {
            if email != nil && email!.characters.count < 30 {
                //over here you need to check if the email is a real email
                
                if email!.contains("@") {
                    correct = true
                }
            }
        }
    }
    private struct AlertMessages {
        static let alertTitle = "Error"
        static let alertMessageForIncorrectUserName = "Please enter a username."
        static let alertMessageforIncorrectPassword1 = "Please make sure you have a least 8 characters and speacial character"
        static let alertMessageForIncorrectPassword2 = "Confirmed password is not the same as passowrd"
        static let alertMessageForIncorrectEmail1 = "email entered was not a proper email"
        static let alertMessageForIncorrectEmail2 = "confirmed email is not the same as email"
        static let exitAlertOption = "Okay"
    }
}

enum StateForSignUp {
    case INCORRECT_USERNAME
    case INCORRECT_PASSWORD1
    case INCORRECT_PASSWORD2
    case INCORRECT_EMAIL1
    case INCORRECT_EMAIL2
    case CORRECT
}
