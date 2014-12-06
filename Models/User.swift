//
//  User.swift
//  ApplePoker
//
//  Created by Simas Abramovas on 12/6/14.
//  Copyright (c) 2014 Simas Abramovas. All rights reserved.
//

import Foundation

class User {

    
    init(username: String, userId: Int?) {
        // Save in core data and create a user
    }
    
    class func saveUserInDB(username: String, userId: Int?) {
        // Save in CoreData
        
    }
    
    class func createUser(username: String, closure: ((error: String, user: User?) -> ())) -> Void {
        let ERROR = "error:"
        var returnString = ""
        var myUser: User?
        
        // Call API with the username
        let userAddUrl = "http://applepoker.herokuapp.com/user/\(username)/add"
        let url: NSURL = NSURL(string: userAddUrl)!
        
        let request: NSURLRequest = NSURLRequest(URL : url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        println("Hello")

        
        NSURLConnection.sendAsynchronousRequest(request, queue : queue, completionHandler:{
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
            var dataString = String(datastring!)
            
            let success = dataString.lowercaseString.rangeOfString(ERROR) == nil;
            if success {
                self.saveUserInDB(username, userId: dataString.toInt());
                // Server created a user, save it in CoreData
                myUser = User(username: username, userId: dataString.toInt());
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