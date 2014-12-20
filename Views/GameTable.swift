//
//  CustomView.swift
//  Home1
//
//  Created by Arūnas Seniucas on 11/22/14.
//  Copyright (c) 2014 Arūnas Seniucas. All rights reserved.
//

import Foundation
import UIKit

class CustomView: UIView{
    var background = UIBezierPath()
    
    //project settings - launch horizontally
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        var ovalPath = UIBezierPath(ovalInRect: rect)
        UIColorFromRGB(0x824B32).setFill()
        ovalPath.fill()
        
        
        var oval2Path = UIBezierPath(ovalInRect: CGRectMake(CGRectGetMinX(rect)+15, CGRectGetMinY(rect)+15, CGRectGetMaxX(rect)-30, CGRectGetMaxY(rect)-30))
        UIColorFromRGB(0x32813C).setFill()
        oval2Path.fill()
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}