//
//  Avatar.swift
//  ApplePoker
//
//  Created by Simas Abramovas on 12/19/14.
//  Copyright (c) 2014 Simas Abramovas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AvatarModel {
    
    var avatarId : Int
    var filename : String
    
    init(avatarId : Int) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let prefix = defaults.stringForKey("avatar_prefix") {
            self.avatarId = avatarId
            self.filename = "\(prefix)_\(avatarId).png"
        } else {
            self.avatarId = -1
            self.filename = ""
            NSException(name: "Avatar exception", reason: "Prefix not found", userInfo: nil).raise()
        }
    }
    
    class func getAvatars() -> [AvatarModel] {
        var results : [AvatarModel] = []
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let avatarsFetch = NSFetchRequest(entityName: "Avatars")
        
        var error: NSError?

        if let avatars = managedContext.executeFetchRequest(avatarsFetch, error: &error) as [NSManagedObject]? {
            if let errorNotNil = error {
                NSException(name: "Avatar exception", reason: "Fetching avatar from DB returned: \(errorNotNil)", userInfo: nil).raise()
            }
            for avatar in avatars {
                let avatarId = avatar.valueForKey("id")! as Int
                results += [AvatarModel(avatarId: avatarId)]
            }
            return results
        } else {
            NSException(name: "Avatar exception", reason: "Fetching avatar ids failed", userInfo: nil).raise()
        }
        
        return results
    }
    
    class func createAvatars() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Avatars", inManagedObjectContext: managedContext)
        let userObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        for i in 0...4 {
            userObject.setValue(i, forKey: "id")
        }
        
        var error: NSError?
        if !managedContext.save(&error) {
            NSException(name: "Avatar exception", reason: "Saving ids failed", userInfo: nil).raise()
        }
    }
    
}