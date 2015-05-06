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
        self.name = username
        self.id = id
        self.money = money
        self.avatar = AvatarModel(avatarId: avatarId)
    }
    
    init(bigUsername: String) {
        let username = bigUsername.lowercaseString
        // Fetch user with "username" from DB
        var error: NSError?
        let predicate = NSPredicate(format: "username = %@", username)
        let result = DbHelper.getFirst("Users", predicate: predicate)
        
        if let result = result {
            name = result.valueForKey("username") as? String
            let avatarId = result.valueForKey("avatarId") as! Int
            avatar = AvatarModel(avatarId: avatarId)
            id = result.valueForKey("id") as! Int?
            money = result.valueForKey("money") as? Int
        } else {
            println("User not found!")
//            NSException(name: "User exception", reason: "Couldn't fetch user (name: \(username)) from DB. It wasn't found.", userInfo: nil).raise()
        }
    }
    
    init(userId: Int) {
        // Fetch user with "userId" from DB
        var error: NSError?
        let predicate = NSPredicate(format: "id = %d", userId)
        let result = DbHelper.getFirst("Users", predicate: predicate)
        
        if let result = result {
            name = result.valueForKey("username") as? String
            let avatarId = result.valueForKey("avatarId") as! Int
            avatar = AvatarModel(avatarId: avatarId)
            id = result.valueForKey("id") as? Int
            money = result.valueForKey("money") as? Int
        } else {
            println("User not found!")
            NSException(name: "User exception", reason: "Couldn't fetch user (id: \(userId)) from DB \(error)", userInfo: nil).raise()
        }
    }
    
    class func saveUserInDB(bigUsername: String, password: String, avatarId: Int, userId: Int?) {
        let username = bigUsername.lowercaseString
        
        var dictionary = NSMutableDictionary()
        dictionary.setValue(username, forKey: "username")
        dictionary.setValue(password, forKey: "password")
        dictionary.setValue(avatarId, forKey: "avatarId")
        dictionary.setValue(userId, forKey: "id")
        dictionary.setValue(Cash.INITIAL.rawValue, forKey: "money")
        
        let predicate = NSPredicate(format: "username = %@", username)
        if !DbHelper.insert("Users", dictionary: dictionary, existancePredicate: predicate) {
            println("User already exists!")
        }
    }
    
    func updateUserInDB(username: String = "", password: String = "", avatarId: Int = -1, userId: Int = -1, money: Int = -1) {
        var error: NSError?
        let predicate = NSPredicate(format: "id = %d", id!)
        
        var dictionary = NSMutableDictionary()
        if !username.isEmpty {
            dictionary.setValue(username, forKey: "username")
        }
        if !password.isEmpty {
            dictionary.setValue(password, forKey: "password")
        }
        if avatarId != -1 {
            dictionary.setValue(avatarId, forKey: "avatarId")
        }
        if money != -1 {
            dictionary.setValue(money, forKey: "money")
        }
        
        if !DbHelper.put("Users", dictionary: dictionary, existancePredicate: predicate) {
            println("New user created, when trying to update user!")
        }
    }
    
    /* Following functions contact the Preferences */
    
    class func getUserIdFromPreferences() -> Int? {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey("user_id") as! Int?
    }
    
    class func saveUserIdToPreferences(userId: Int) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(userId, forKey: "user_id")
        defaults.synchronize()
    }
    
    class func clearUserIdFromPreferences() {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("user_id")
        defaults.synchronize()
    }
    
    class func getUserFromPreferences() -> User? {
        let userId = getUserIdFromPreferences()
        println("GOT ID \(userId)")
        if let userId = userId {
            return User(userId: userId)
        } else {
            return nil
        }
    }
    
    /* Following functions contact the server */
    
    // ToDo remove password default val
    class func createUser(bigUsername: String, password: String = "", avatarId: Int = 0, callback: ((error: String, user: User?) -> ())) -> Void {
        if bigUsername.isEmpty {
            callback(error: "Username cannot be empty!", user: nil);
            return
        } else if password.isEmpty && false {
            callback(error: "Password cannot be empty!", user: nil);
            return
        } else if let count = bigUsername.contains("[^-a-zA-Z0-9]") {
            callback(error: "Username contains \(count) illegal character(s)! Try again.", user: nil)
            return
        } else if let count = password.contains("[^-a-zA-Z0-9]") {
            callback(error: "Password contains \(count) illegal characters! Try again.", user: nil)
            return
        }
        
        let username = bigUsername.lowercaseString
        
        let url = ServerHelper.urlAddUser(username)
        ServerHelper.asyncQuery(url, callback: { (response: String) -> () in
            let cleanResponse = response.stringByReplacingOccurrencesOfString(ServerHelper.CONST.ERROR.rawValue, withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
            if (count(response) == count(cleanResponse)) {
                let id = response.toInt()!
                
                // ToDo cia apkeist vietom, kad sukurti useri imant is DB. T.y. User(identifier)
                let user = User(username: username, password: password, avatarId: avatarId, id: id, money: Cash.INITIAL.rawValue);
                self.saveUserInDB(username, password: password, avatarId: avatarId, userId: id);
                self.saveUserIdToPreferences(id)
                
                // Callback on UI thread with the new user
                dispatch_async(dispatch_get_main_queue(), {
                    callback(error: "", user: user);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    callback(error: cleanResponse, user: nil);
                });
            }
        })
    }
    
    class func removeUser(id: Int, callback: ((error: String) -> ())) {
        let ERROR = "error:"
        // Remove from DB
        var error: NSError?
        let predicate = NSPredicate(format: "id = %d", id)
        if !DbHelper.remove("Users", predicate: predicate, error: &error) {
            println("Couldn't remove the user from DB, got error: \(error)")
        }
        
        // Remove from preferences
        clearUserIdFromPreferences()
        // Remove from server
        let url = ServerHelper.urlRemoveUser(id)
        ServerHelper.asyncQuery(url, callback: { (response: String) -> () in
            let cleanResponse = response.stringByReplacingOccurrencesOfString(ServerHelper.CONST.ERROR.rawValue, withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
            if (count(cleanResponse) == count(response)) {
                dispatch_async(dispatch_get_main_queue(), {
                    callback(error: "");
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    callback(error: cleanResponse);
                });
            }
        })
    }
    
    func updateAvatar(avatarId: Int) {
        avatar = AvatarModel(avatarId: avatarId)
        updateUserInDB(avatarId: avatarId)
        
        let url = ServerHelper.urlSetAvatar(id!, avatarId: avatarId)
        ServerHelper.asyncQuery(url, callback: { (response: String) -> () in
            // Check if returned the same img url
            if response.rangeOfString("\(avatarId)") == nil {
                NSException(name: "User Exception", reason: "Server failed when setting the avatar id: \(response) when calling \(url)", userInfo: nil).raise()
            }
        })
    }
    
    /* Remove user from preferences, server and DB */
    class func purgeUser(id: Int, callback: (() -> ())? = nil) {
        // Preferences
        println("When purging id: \(id)")
        if let prefId = getUserIdFromPreferences() {
            if prefId == id {
                clearUserIdFromPreferences()
            }
        }
        
        let t = getUserIdFromPreferences()
        
        // Database
        let predicate = NSPredicate(format: "id = %d", id)
        DbHelper.remove("Users", predicate: predicate)
        
        // Server
        let url = ServerHelper.urlRemoveUser(id)
        ServerHelper.asyncQuery(url, callback: { (response: String) -> () in
            println(url)
            println(response)
            callback?()
        })
    }
    
}