//  User.swift
//  ApplePoker
//
//  Created by Simas Abramovas on 12/6/14.
//  Copyright (c) 2014 Simas Abramovas. All rights reserved.

import Foundation
import UIKit
import CoreData

class User {

    var name: String?
    var avatarUrl: String?
    var id: Int?
    var money: Int?
    
    init() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let userFetch = NSFetchRequest(entityName: "Users")
        var error: NSError?
        
        let usersResult = managedContext.executeFetchRequest(userFetch, error: &error) as [NSManagedObject]?
        
        if let results = usersResult {
            let user = results[results.count - 1]
            name = user.valueForKey("username") as String!
            avatarUrl = user.valueForKey("avatar") as String!
            id = user.valueForKey("id") as Int!
            money = user.valueForKey("money") as Int!
        } else {
            println("Error couldn't fetch the user from DB")
        }
    }
    
    func getAvatarUrl() -> String? {
        return avatarUrl
    }
    
    func getName() -> String? {
        return name
    }
    
    func getId() -> Int? {
        return id
    }
    
    func getMoney() -> Int? {
        return money
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
        userObject.setValue(10000, forKey: "money")

        var error: NSError?
        if !managedContext.save(&error) {
            println("Error while saving the user")
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
                // User added, now try to set avatar
                let identifier = dataString.toInt()!
                let avatarSetUrl = "http://applepoker.herokuapp.com/user/\(identifier)/update/avatar?url=\(imageUrl)"
//
//                let fixedImageUrl = imageUrl.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
//                let fixedUrl = avatarSetUrl + fixedImageUrl!

                let url: NSURL = NSURL(string: avatarSetUrl)!


                let request: NSURLRequest = NSURLRequest(URL : url)
                
                NSURLConnection.sendAsynchronousRequest(request, queue : queue, completionHandler:{
                    (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    var datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
                    var dataString = String(datastring!)

                    let success = dataString.rangeOfString(imageUrl) != nil;
                    if success {
                        self.saveUserInDB(username, imageUrl: imageUrl, userId: identifier);
                        myUser = User();
                    } else {
                        returnString = dataString
                    }
                    // Callback on UI Thread
                    dispatch_async(dispatch_get_main_queue(),{
                        closure(error: returnString, user: myUser);
                    });
                })
            } else {
                returnString = dataString
                // Callback on UI Thread
                dispatch_async(dispatch_get_main_queue(),{
                    closure(error: returnString, user: myUser);
                });
            }
            
        })
    }

}