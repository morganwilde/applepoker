//
//  DBHelper.swift
//  ApplePoker
//
//  Created by Simas Abramovas on 12/20/14.
//  Copyright (c) 2014 Simas Abramovas. All rights reserved.
//

import Foundation
import CoreData

class DbHelper {
    
    class var sharedInstance: DbHelper {
        struct Static {
            static var instance: DbHelper?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DbHelper()
        }
        
        return Static.instance!
    }
    
    var moc : NSManagedObjectContext = NSManagedObjectContext()
    
    // ToDo a new variable that points to sharedInstance.moc
    
}