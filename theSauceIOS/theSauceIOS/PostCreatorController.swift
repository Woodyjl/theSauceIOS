//
//  PostCreatorController.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/25/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import UIKit
import MapKit

class PostCreatorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PostResultDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    
    var locationManager = CLLocationManager()
    let mapView = MKMapView()
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostCreatorController.openLocationSearch(_ :)))
        locationLabel.addGestureRecognizer(tapGesture)
        locationLabel.isUserInteractionEnabled = true
        
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostCreatorController.selectAnImage(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        let postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.post(_:)))
        self.navigationItem.rightBarButtonItem = postButton
    }
    
    func post(_ sender: UIBarButtonItem) {
        if let userId = self.userId {
            if let image = imageView.image {
                let date = Date()
                let formatter = DateFormatter()
                // Format for date
                formatter.dateFormat = "MM/dd/yyyy"
                let result = formatter.string(from: date)
                
                let imageData = UIImageJPEGRepresentation(image, 1.0)!
                let post = Post(userId: userId, dateTaken: result, location: locationLabel.text!, caption: captionTextView.text, image: imageData)
                do {
                   try post.uploadToCloud(resultDelegate: self)
                } catch let ex {
                    print("----------------------------------------------------------------------------------")
                    print(ex.localizedDescription)
                    print("----------------------------------------------------------------------------------")
                }
            }
        }
    }
    
    func didUploadSuceed(success: Bool, error: Error?) {
        print("----------------------------------------------------------------------------------")
        if success {
            self.navigationController?.popToRootViewController(animated: true)
        }
        print(success)
        print(error?.localizedDescription)
        print("----------------------------------------------------------------------------------")
    }
    
    func openLocationSearch(_ gesture: UITapGestureRecognizer) {
        print("tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultControllerNav") as! UINavigationController
        let searchCon = controller.getRoot() as? SearchResultController
        searchCon?.mapView = mapView
        present(controller, animated: true, completion: nil)
    }
    
    func selectAnImage(_ gesture: UITapGestureRecognizer)  {
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
        
        self.present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })

    }
    
    func alertControllerBackgroundTapped(){
        print("in this biiiich")
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else{
            print("Something went wrong")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //implement
        
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }


    
    func goBack(_ segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            
        }
    }

}

extension PostCreatorController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}
