//  User.swift
//  ApplePoker
//
//  Created by Simas Abramovas on 12/6/14.
//  Copyright (c) 2014 Simas Abramovas. All rights reserved.

import Foundation
import UIKit
import CoreData

class User {

    init(username: String) {
        // Save in core data and create a user
    }

    class func saveUserInDB(username: String, imageUrl: String, userId: Int?) {
        // Save in CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!

        let entity = NSEntityDescription.entityForName("Users", inManagedObjectContext: managedContext)
        let userObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)

        userObject.setValue(username, forKey: "username")
        userObject.setValue(imageUrl, forKey: "avatar")
        userObject.setValue(userId, forKey: "id")

        var error: NSError?
        if !managedContext.save(&error) {
            println("err")
        }
    }

    class func createUser(username: String, imageUrl: String, closure: ((error: String, user: User?) -> ())) -> Void {
        let ERROR = "error:"
        var returnString = ""
        var myUser: User?

        // Call API with the username
        let userAddUrl = "http://applepoker.herokuapp.com/user/\(username)/add"
        let url: NSURL = NSURL(string: userAddUrl)!

        let request: NSURLRequest = NSURLRequest(URL : url)
        let queue: NSOperationQueue = NSOperationQueue()

        NSURLConnection.sendAsynchronousRequest(request, queue : queue, completionHandler:{
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
            var dataString = String(datastring!)
            
            // Check if this user was added
            let success = dataString.lowercaseString.rangeOfString(ERROR) == nil;
            if success {
                self.saveUserInDB(username, imageUrl: imageUrl, userId: dataString.toInt());
                // Server created a user, save it in CoreData
                myUser = User(username: username);
            } else {
                returnString = dataString
            }
            
            // Callback on UI Thread
            dispatch_async(dispatch_get_main_queue(),{
                closure(error: returnString, user: myUser);
            });
        })
    }

}