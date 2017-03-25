//
//  SharedData.swift
//  theSauceIOS
//
//  Created by Woody Jean-Louis on 12/27/16.
//  Copyright © 2016 Woody Jean-Louis. All rights reserved.
//

import Foundation
import UIKit


class SharedData {
    static var alreadyFetchedPostPhotos = [String : Data]()
    static var alreadyFetchedProfileImage = [String : Data]()
    
    
    static func notificationBubble(text: String, with frame: CGRect) -> UIView {
        print(frame)
        let bubbleView = UIView(frame: frame)
        bubbleView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        bubbleView.layer.cornerRadius = 5
        
        let textView = UITextView(frame: CGRect(x: frame.width/8, y: frame.height/8, width: (frame.width/8) * 6, height: (frame.height/8) * 6))
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.text = text
        textView.font = UIFont(name: "HelveticaNeue-UltraLight", size: 15)
        textView.textAlignment = NSTextAlignment.center
        
        
        bubbleView.addSubview(textView)
        bubbleView.sizeToFit()
        
        return bubbleView
    }

}

