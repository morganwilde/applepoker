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
        var image = UIImage(named: imageName, forState:UIControlState.Normal)
        self.setImage(image)
    }
    
}
