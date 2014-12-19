//  User.swift
//  ApplePoker
//
//  Created by Simas Abramovas on 12/6/14.
//  Copyright (c) 2014 Simas Abramovas. All rights reserved.

import UIKit
import CoreData

// SERVER AND COREDATA ALWAYS RECEIVES/RETURNS LOWERCASE USERNAMES

class User {
    
    enum Cash : Int {
        case INITIAL = 10000
    }
    
    var name: String?
    var avatarUrl: String?
    var id: Int?
    var money: Int?
    
    init(username: String, imageUrl: String, id: Int, money: Int) {
        name = username;
        avatarUrl = imageUrl
        self.id = id
        self.money = money
    }
    
    init(bigUsername: String) {
        let username = bigUsername.lowercaseString
        // Fetch user with "username" from DB
        var error: NSError?
        let predicate = NSPredicate(format: "username = %@", username)
        println(predicate);
        
        let usersResult = fetchFromDb(predicate, error: &error)
        if let results = usersResult? {
            if results.count > 0 {
                let userData = results[0]
                name = userData.valueForKey("username") as? String
                avatarUrl = userData.valueForKey("avatar") as? String
                id = userData.valueForKey("id") as Int?
                println("User exists in CoreData, id='\(id)'")
                println("User exists in CoreData, name='\(name)'")
                println("Looked for , username='\(username)'")
                money = userData.valueForKey("money") as? Int
            } else {
                println("Error while fetching the user (name: \(username)) from DB. It wasn't found.")
            }
        } else {
            println("Error while fetching the user (name: \(username)) from DB \(error?)")
        }
    }
    
    init(userId: Int) {
        // Fetch user with "userId" from DB
        var error: NSError?
        let predicate = NSPredicate(format: "id = %d", userId)
        
        let usersResult = fetchFromDb(predicate, error: &error)
        if let results = usersResult {
            if results.count > 0 {
                let userData = results[0]
                name = userData.valueForKey("username") as? String
                avatarUrl = userData.valueForKey("avatar") as? String
                id = userData.valueForKey("id") as? Int
                money = userData.valueForKey("money") as? Int
            } else {
                println("Error while fetching the user (name: \(userId)) from DB. It wasn't found.")
            }
        } else {
            println("Error couldn't fetch the user (id: \(userId)) from DB \(error?)")
        }
    }
    
    func fetchFromDb(predicate: NSPredicate?, error: NSErrorPointer) -> [NSManagedObject]? {
        // This doesn't implicitly create test breakpoints
        //        let appDelegate: AppDelegate = AppDelegate()
        //        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let userFetch = NSFetchRequest(entityName: "Users")
        userFetch.predicate = predicate
        
        return managedContext.executeFetchRequest(userFetch, error: error) as [NSManagedObject]?
    }
    
    class func saveUserInDB(bigUsername: String, imageUrl: String, userId: Int?) {
        let username = bigUsername.lowercaseString
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Users", inManagedObjectContext: managedContext)
        let userObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        userObject.setValue(username, forKey: "username")
        userObject.setValue(imageUrl, forKey: "avatar")
        userObject.setValue(userId, forKey: "id")
        userObject.setValue(Cash.INITIAL.rawValue, forKey: "money")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Error while saving the user (name: \(username): \(error?)")
        }
    }
    
    class func removeUser(id: Int, callback: ((error: String) -> ())) {
        let ERROR = "error:"
        var error: NSError?
        
        // Delete from CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let userFetch = NSFetchRequest(entityName: "Users")
        userFetch.predicate = NSPredicate(format: "id == '\(id)'")
        
        let usersResult = managedContext.executeFetchRequest(userFetch, error: &error) as [NSManagedObject]?
        
        if let results = usersResult {
            if (results.count > 0) {
                managedContext.deleteObject(results[0])
            } else {
                println("Error while fetching the user (id: \(id)) from DB. It wasn't found.")
            }
        } else {
            println("Failed to fetch the user (id: \(id)) from DB for deletion.")
        }
        if (!managedContext.save(&error)) {
            println("Failed to delete user (id: \(id)) from DB \(error?)")
        }
        
        // Delete from server
        let userAddUrl = "http://applepoker.herokuapp.com/user/\(id)/remove"
        let url: NSURL = NSURL(string: userAddUrl)!
        let request: NSURLRequest = NSURLRequest(URL : url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue : queue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let deletionReturn = NSString(data: data, encoding: NSUTF8StringEncoding)
            let deletionResult = String(deletionReturn!)
            
            // Make sure no errors returned
            var returnString = ""
            let success = (deletionResult.lowercaseString.rangeOfString(ERROR) == nil);
            if !success {
                returnString = deletionResult
            }
            
            // Callback on UI Thread
            dispatch_async(dispatch_get_main_queue(), {
                callback(error: returnString);
            });
        })
    }
    
    class func createUser(bigUsername: String, imageUrl: String, callback: ((error: String, user: User?) -> ())) -> Void {
        let ERROR = "error:"
        let username = bigUsername.lowercaseString
        let queue: NSOperationQueue = NSOperationQueue()
        // Return values
        var returnString = ""
        var myUser: User?
        
        // Try to register
        let userAddUrl = "http://applepoker.herokuapp.com/user/\(username)/add"
        let url: NSURL = NSURL(string: userAddUrl)!
        let request: NSURLRequest = NSURLRequest(URL : url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue : queue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let addReturn = NSString(data: data, encoding: NSUTF8StringEncoding)
            let addResult = String(addReturn!)
            
            // Make sure no errors returned
            let success = (addResult.lowercaseString.rangeOfString(ERROR) == nil);
            if success {
                // User registered, now set the avatar
                let identifier = addResult.toInt()!
                
                let avatarSetUrl = "http://applepoker.herokuapp.com/user/\(identifier)/update/avatar?url=\(imageUrl)"
                let url: NSURL = NSURL(string: avatarSetUrl)!
                let request: NSURLRequest = NSURLRequest(URL : url)
                
                NSURLConnection.sendAsynchronousRequest(request, queue : queue, completionHandler: {
                    (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    let avatarReturn = NSString(data: data, encoding: NSUTF8StringEncoding)
                    let avatarResult = String(avatarReturn!)
                    
                    // Check if returned the same img url
                    let success = avatarResult.rangeOfString(imageUrl) != nil;
                    if success {
                        self.saveUserInDB(username, imageUrl: imageUrl, userId: identifier);
                        myUser = User(username: username, imageUrl: imageUrl, id: identifier, money: Cash.INITIAL.rawValue);
                    } else {
                        returnString = avatarResult
                    }
                    // Callback on UI Thread
                    dispatch_async(dispatch_get_main_queue(), {
                        callback(error: returnString, user: myUser);
                    });
                })
            } else {
                returnString = addResult
                // Callback on UI Thread
                dispatch_async(dispatch_get_main_queue(), {
                    callback(error: returnString, user: myUser);
                });
            }
        })
    }
    
}