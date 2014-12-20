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
    
}
