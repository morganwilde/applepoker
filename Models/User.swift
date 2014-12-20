//  User.swift
//  ApplePoker
//
//  Created by Simas Abramovas on 12/6/14.
//  Copyright (c) 2014 Simas Abramovas. All rights reserved.

import Foundation
import UIKit
import CoreData

// SERVER AND COREDATA ALWAYS RECEIVES/RETURNS LOWERCASE USERNAMES

class User {
    
    enum Cash : Int {
        case INITIAL = 10000
    }
    
    var name: String?
    var avatar: AvatarModel?
    var id: Int?
    var money: Int?
    
    init(username: String, password: String, avatarId: Int, id: Int, money: Int) {
        name = username
        self.id = id
        self.money = money
        updateAvatar(avatarId)
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
                let avatarId = userData.valueForKey("avatarId") as Int
                avatar = AvatarModel(avatarId: avatarId)
                id = userData.valueForKey("id") as Int?
                money = userData.valueForKey("money") as? Int
            } else {
//                NSException(name: "User exception", reason: "Couldn't fetch user (name: \(username)) from DB. It wasn't found.", userInfo: nil).raise()
            }
        } else {
            NSException(name: "User exception", reason: "Couldn't fetch user (name: \(username)) from DB \(error?)", userInfo: nil).raise()
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
                let avatarId = userData.valueForKey("avatarId") as Int
                avatar = AvatarModel(avatarId: avatarId)
                id = userData.valueForKey("id") as? Int
                money = userData.valueForKey("money") as? Int
            } else {
//                NSException(name: "User exception", reason: "Couldn't fetch user (id: \(userId)) from DB. It wasn't found.", userInfo: nil).raise()
            }
        } else {
            NSException(name: "User exception", reason: "Couldn't fetch user (id: \(userId)) from DB \(error?)", userInfo: nil).raise()
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
    
    class func saveUserInDB(bigUsername: String, password: String, avatarId: Int, userId: Int?) {
        let username = bigUsername.lowercaseString
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Users", inManagedObjectContext: managedContext)
        let userObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        userObject.setValue(username, forKey: "username")
        userObject.setValue(username, forKey: "password")
        userObject.setValue(avatarId, forKey: "avatarId")
        userObject.setValue(userId, forKey: "id")
        userObject.setValue(Cash.INITIAL.rawValue, forKey: "money")
        
        var error: NSError?
        if !managedContext.save(&error) {
            NSException(name: "User exception", reason: "Couldn't save user (name: \(username): \(error?)", userInfo: nil).raise()
        }
    }
    
    func updateUserInDB(username: String = "", password: String = "", avatarId: Int = -1) {
        var error: NSError?
        
        // Delete from CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let userFetch = NSFetchRequest(entityName: "Users")
        userFetch.predicate = NSPredicate(format: "id == '\(id?)'")
        
        let usersResult = managedContext.executeFetchRequest(userFetch, error: &error) as [NSManagedObject]?
        
        if let results = usersResult {
            if (results.count > 0) {
                if !username.isEmpty {
                    managedContext.setValue(username, forKey: "username")
                }
                if !password.isEmpty {
                    managedContext.setValue(password, forKey: "password")
                }
                if avatarId != -1 {
                    managedContext.setValue(avatarId, forKey: "avatarId")
                }
            } else {
                NSException(name: "User exception", reason: "Couldn't fetch user (id: \(id?)) from DB. It wasn't found.", userInfo: nil).raise()
            }
        } else {
            NSException(name: "User exception", reason: "Couldn't fetch user (id: \(id?)) from DB for updating.", userInfo: nil).raise()
        }
        if (!managedContext.save(&error)) {
            NSException(name: "User exception", reason: "Couldn't fetch user (id: \(id?)) from DB \(error?)", userInfo: nil).raise()
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
                NSException(name: "User exception", reason: "Couldn't fetch user (id: \(id)) from DB. It wasn't found.", userInfo: nil).raise()
            }
        } else {
            NSException(name: "User exception", reason: "Couldn't fetch user (id: \(id)) from DB for deletion.", userInfo: nil).raise()
        }
        if (!managedContext.save(&error)) {
            NSException(name: "User exception", reason: "Couldn't fetch user (id: \(id)) from DB \(error?)", userInfo: nil).raise()
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
                returnString = deletionResult.stringByReplacingOccurrencesOfString("error: ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
                // Remove "error: "
            }
            
            // Callback on UI Thread
            dispatch_async(dispatch_get_main_queue(), {
                callback(error: returnString);
            });
        })
    }
    
    class func createUser(bigUsername: String, password: String = "", avatarId: Int = 0, callback: ((error: String, user: User?) -> ())) -> Void {
        if bigUsername.isEmpty {
            callback(error: "Username cannot be empty!", user: nil);
        } else if password.isEmpty && false {
            callback(error: "Password cannot be empty!", user: nil);
        }
        
        // ToDo password/bigUsername regex #$%^&*(OP
        
        
        let ERROR = "error:"
        let username = bigUsername.lowercaseString
        let queue: NSOperationQueue = NSOperationQueue()
        // Return values
        var returnString = ""
        var myUser: User?
        
        // Try to register
        let userAddUrl = "http://applepoker.herokuapp.com/user/\(username)/add"
        let userAddURL: NSURL = NSURL(string: userAddUrl)!
        let request: NSURLRequest = NSURLRequest(URL : userAddURL)
        
        NSURLConnection.sendAsynchronousRequest(request, queue : queue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let addReturn = NSString(data: data, encoding: NSUTF8StringEncoding)
            let addResult = String(addReturn!)
            
            // Make sure no errors returned
            let success = (addResult.lowercaseString.rangeOfString(ERROR) == nil);
            if success {
                // User registered, now set the avatar
                let identifier = addResult.toInt()!
                
                myUser = User(username: username, password: password, avatarId: avatarId, id: identifier, money: Cash.INITIAL.rawValue);
                self.saveUserInDB(username, password: password, avatarId: avatarId, userId: identifier);
                self.saveUserToPreferences(myUser!)
            } else {
                returnString = addResult.stringByReplacingOccurrencesOfString("error: ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
                // Callback on UI Thread
                dispatch_async(dispatch_get_main_queue(), {
                    callback(error: returnString, user: myUser);
                });
            }
            
            // Callback on UI thread with the new user
            dispatch_async(dispatch_get_main_queue(), {
                callback(error: returnString, user: myUser);
            });
        })
    }
    
    class func saveUserToPreferences(user: User) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(user.id!, forKey: "user_id")
        defaults.synchronize()
    }
    
    class func clearUserFromPreferences() {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("user_id")
        defaults.synchronize()
    }
    
    class func getUserFromPreferences() -> User? {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let userId: AnyObject = defaults.valueForKey("user_id" ) {
            let user = User(userId: userId as Int)
            return user
        } else {
            return nil
        }
    }
    
    func updateAvatar(avatarId : Int) {
        avatar = AvatarModel(avatarId: avatarId)
//        updateUserInDB(avatarId: avatarId)
        
        // Avatar request for server
        let avatarSetterUrl = "http://applepoker.herokuapp.com/user/\(id!)/update/avatar?url=\(avatarId)"
        let avatarSetterURL: NSURL = NSURL(string: avatarSetterUrl)!
        let request: NSURLRequest = NSURLRequest(URL : avatarSetterURL)
        
        let queue: NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue : queue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let avatarReturn = NSString(data: data, encoding: NSUTF8StringEncoding)
            let serverResult = String(avatarReturn!)
            
            // Check if returned the same img url
            if serverResult.rangeOfString("\(avatarId)") == nil {
                NSException(name: "User exception", reason: "Server failed when setting the avatar id: \(serverResult) when calling \(avatarSetterURL)", userInfo: nil).raise()
            }
        })
    }
    
}