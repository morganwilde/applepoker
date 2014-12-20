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
        
        var borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        var backColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.CGColor
        self.backgroundColor = backColor
        
        self.setTitleColor(borderColor, forState: UIControlState.Normal)
        
    }
}
