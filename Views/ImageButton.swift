//
//  ImageButton.swift
//  ApplePoker
//
//  Created by Arūnas Seniucas on 12/19/14.
//  Copyright (c) 2014 Arūnas Seniucas. All rights reserved.
//

import UIKit

class ImageButton: UIButton{
    
    
    
    func setInternalImage(imageName: String) -> (){
        
        self.layer.cornerRadius = 10
        var image = UIImage(named: imageName)
        self.setImage(image, forState: UIControlState.Normal)
        self.setNeedsDisplay()
    }
    
    /*tautvydui idet i registration controlleri
    
    RegistationButton:
    var borderColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    var backColor = UIColor(red: 0.0, green: 0.3, blue: 1.0, alpha: 0.7)
    
    self.layer.cornerRadius = 10
    registrationButton.layer.borderWidth = 2
    registrationButton.layer.borderColor = borderColor.CGColor
    registrationButton.backgroundColor = backColor
    
    UserField
    
    var borderColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    
    self.layer.cornerRadius = 10
    testField.layer.borderWidth = 2
    testField.layer.borderColor = borderColor.CGColor
    
    passfield
    
    var borderColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    
    self.layer.cornerRadius = 10
    testField.layer.borderWidth = 2
    testField.layer.borderColor = borderColor.CGColor
*/
    
}
