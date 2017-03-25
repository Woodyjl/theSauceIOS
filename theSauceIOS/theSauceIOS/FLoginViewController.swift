//
//  LoginScreenViewController.swift
//  ChubbyHubbyPractice
//
//  Created by Woody Jean-Louis on 10/31/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import FirebaseAuth

class FLoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userName.text = "drake@gmail.com"
        passWord.text = "12341234"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let field1 = userName.text
        let field2 = passWord.text
        
        if (field1 != nil && field2 != nil) {
            if (field1! == "" && field2! == "") {
                let alert = UIAlertController(title: AlertMessages.alertTitle, message: AlertMessages.alertMessageForDoubleEmpty, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: AlertMessages.exitAlertOption, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if (field1! == "" || field2! == "") {
                let alert = UIAlertController(title: AlertMessages.alertTitle, message: AlertMessages.alertMessageForSingleEmpty, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: AlertMessages.exitAlertOption, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                loginUser(email: field1!, passWord: field2!)
            }
        }
    }
    
    private func loginUser(email field1: String?, passWord field2: String?) {
        spinner.startAnimating()
        
        let firebaseAuth = FIRAuth.auth()
        
        if field1 != nil && field2 != nil {
            firebaseAuth?.signIn(withEmail: field1!, password: field2!, completion: { [unowned self] (user: FIRUser?, error: Error?) in
                self.spinner.stopAnimating()
                
                if user != nil {
                    OperationQueue.main.addOperation {
                        // when done, update your UI and/or model on the main queue
                        //self.goToLobby(user: user?)
                        print("Login successful")
                        
                    }
                } else {
                    OperationQueue.main.addOperation {
                        
                        //implement
                        
                        let alert = UIAlertController(title: AlertMessages.alertTitle, message: AlertMessages.alertMessageIncorrectlogin, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: AlertMessages.exitAlertOption, style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                })
        }
        
        
            
            //Implement in the feature that locks someone's account after a certain number of attempts
    }
    
    public func goToLobby(user: FIRUser) {
        print("should perform segue")
        //performSegue(withIdentifier: "goToHome", sender: nil)
    }
    
    
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let whereToGo = segue.identifier {
            switch whereToGo {
            case "SignUpPage":
                //let destinationVC = segue.destination as? SignUpViewController
                //Do more things like pass helpful information
                break
            case "backFromSignUp":
                loginUser(email: nil, passWord: nil)
                break
            default:
                break
            }
        }
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        
    }
    
    private struct AlertMessages {
        static let alertTitle = "Error"
        static let alertMessageForDoubleEmpty = "Please Enter username and password."
        static let alertMessageForSingleEmpty = "Please Enter missing information."
        static let alertMessageIncorrectlogin = "The username or password you entered was incorrect. Please try again"
        static let exitAlertOption = "Okay"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
