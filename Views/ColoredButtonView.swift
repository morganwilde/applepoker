//
//  ColoredButtonView.swift
//  ApplePoker
//
//  Created by Arūnas Seniucas on 12/20/14.
//  Copyright (c) 2014 Arūnas Seniucas. All rights reserved.
//

import UIKit

class ColoredButtonView: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var borderColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        var backColor = UIColor(red: 0.0, green: 0.3, blue: 1.0, alpha: 0.7)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.CGColor
        self.backgroundColor = backColor
        
    }
}
