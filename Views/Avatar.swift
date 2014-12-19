//
//  Avatar.swift
//  ApplePoker
//
//  Created by Arūnas Seniucas on 12/6/14.
//  Copyright (c) 2014 Arūnas Seniucas. All rights reserved.
//

import Foundation
import UIKit
// wut?


class Avatar:UIImageView{
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func Temp() -> (){
        var onlineImageStorage: String?
        var onlineImage: String {
            get {
                return onlineImageStorage!
            }
            set {
                onlineImageStorage = newValue
                
                dispatch_async(dispatch_get_main_queue(), {
                    //let url0 = NSURL(string:"http://whatscookingamerica.net/Vegetables/Russet_Potato.jpg")
                    
                    let url0 = NSURL(string: newValue)
                    let data = NSData(contentsOfURL: url0!)
                    let timage = UIImage(data: data!)
                    
                    self.image = timage
                    self.setNeedsDisplay()
                })
            }
        }
    }
    
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}