//
//  CustomBorderVIew.swift
//  Home1
//
//  Created by Arūnas Seniucas on 12/20/14.
//  Copyright (c) 2014 Arūnas Seniucas. All rights reserved.
//

import UIKit

class CustomBorderView: UIView {
    let screenSize = UIScreen.mainScreen().bounds
    var borders = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    //init(drawWithin view: UIView, atY y: CGFloat) {
    //    let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + y, width: view.frame.size.width, height: 1)
    //    super.init(frame: frame)
    //}
    
    init(drawWithin view: UIView, passingFrame pFrame: CGRect) {
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + pFrame.origin.y, width: view.frame.size.width, height: pFrame.height)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let startingX: CGFloat = 0.0
        let endingX: CGFloat = rect.width
        
        let minY: CGFloat = 0.0
        let maxY: CGFloat = rect.height
        
        var lineTop = CGRect(x: startingX, y: minY, width: endingX, height: 1)
        borders = UIBezierPath(rect: lineTop)
        UIColor.blackColor().setFill()
        borders.fill()
        
        
        var lineBot = CGRect(x: startingX, y: maxY-1, width: endingX, height: 1)
        borders = UIBezierPath(rect: lineBot)
        UIColor.blackColor().setFill()
        borders.fill()
        
        
    }
    
    
}
