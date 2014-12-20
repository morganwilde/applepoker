//
//  ColoredTextField.swift
//  ApplePoker
//
//  Created by Arūnas Seniucas on 12/20/14.
//  Copyright (c) 2014 Arūnas Seniucas. All rights reserved.
//

import UIKit

class ColoredTextField: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var borderColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.CGColor
        
    }
}
