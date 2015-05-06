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
            self.filename = "\(prefix)\(avatarId).png"
        } else {
            self.avatarId = -1
            self.filename = ""
            NSException(name: "Avatar exception", reason: "Prefix not found", userInfo: nil).raise()
        }
    }
    
    class func getAvatars() -> [AvatarModel] {
        var error: NSError?
        if let results = DbHelper.get("Avatars", predicate: nil, error: &error) {
            if let error = error {
                NSException(name: "Avatar exception", reason: "Fetching avatars from DB returned: \(error)", userInfo: nil).raise()
            }
            
            var avatars : [AvatarModel] = []
            for result in results {
                let avatarId = result.valueForKey("id")! as! Int
                avatars += [AvatarModel(avatarId: avatarId)]
            }

            avatars.sort { (model1, model2) -> Bool in
                return model1.avatarId < model2.avatarId
            }
            return avatars
        } else {
            NSException(name: "Avatar exception", reason: "Fetching avatar ids failed", userInfo: nil).raise()
        }
        return []
    }
    
    class func createAvatars() {
        // Dont create avatars if they exist
        if getAvatars().count > 0 {
            return
        }
        
        var dictionaries = [NSMutableDictionary]()
        for i in 0...4 {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(i, forKey: "id")
            dictionaries.append(dictionary)
        }
        DbHelper.insert("Avatars", dictionaries: dictionaries)
    }
    
}