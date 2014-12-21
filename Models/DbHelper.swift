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
    
    // ToDo a new variable that points to sharedInstance.moc
    var moc : NSManagedObjectContext = NSManagedObjectContext()
    
    class func get(entityName: String, predicate: NSPredicate?, error: NSErrorPointer) -> [NSManagedObject]? {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        
        return sharedInstance.moc.executeFetchRequest(request, error: error) as [NSManagedObject]?
    }
    
    class func getFirst(entityName: String, predicate: NSPredicate?, error: NSErrorPointer = NSErrorPointer()) -> NSManagedObject? {
        let results = get(entityName, predicate: predicate, error: error)
        if let results = results {
            if results.count > 0 {
                return results[0]
            }
        }
        println(error)
        
        return nil
    }
    
    /* Overwrites existing data
     * Returns true if overwritten
     */
    class func put(entityName: String, dictionary: NSMutableDictionary, existancePredicate: NSPredicate, error: NSErrorPointer = nil) -> Bool {
        var managedObject : NSManagedObject
        var overwritten = false
        let result = getFirst(entityName, predicate: existancePredicate, error: error)
        if let result = result {
            overwritten = true
            managedObject = result
        } else {
            let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: sharedInstance.moc)
            managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: sharedInstance.moc)
        }

        managedObject.setValuesForKeysWithDictionary(dictionary)
        
        if error == nil {
            var error = NSErrorPointer()
            if !sharedInstance.moc.save(error) {
                NSException(name: "DB Exception", reason: "Couldn't add the dictionary: \(dictionary) with error: \(error)", userInfo: nil).raise()
            }
        } else {
            // Handle errors manually
            sharedInstance.moc.save(error)
        }
        
        return overwritten
    }

    /* Aborts if exists, based on existancePredicate
     * Returns true if inserted
     */
    class func insert(entityName: String, dictionary: NSMutableDictionary, existancePredicate: NSPredicate? = nil, error: NSErrorPointer = nil) -> Bool {
        if existancePredicate != nil {
            let result = getFirst(entityName, predicate: existancePredicate, error: error)
            if let result = result {
                return false
            }
        }
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: sharedInstance.moc)
        let managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: sharedInstance.moc)
        managedObject.setValuesForKeysWithDictionary(dictionary)
        
        if error == nil {
            var error: NSError?
            if !sharedInstance.moc.save(&error) {
                NSException(name: "DB Exception", reason: "Couldn't add the dictionary: \(dictionary) with error: \(error?)", userInfo: nil).raise()
            }
        } else {
            // Handle errors manually
            sharedInstance.moc.save(error)
        }
        
        return true
    }
    
    class func insert(entityName: String, dictionaries: [NSMutableDictionary], error: NSErrorPointer = nil) {
        for dictionary in dictionaries {
            insert(entityName, dictionary: dictionary, error: error)
            println(dictionary)
        }
    }
    
    /* Removes all matching results
     * Returns true if anything removed */
    class func remove(entityName: String, predicate: NSPredicate?, error: NSErrorPointer = nil) -> Bool {
        var removed = false
        let results = get(entityName, predicate: predicate, error: error)
        if let results = results {
            for result in results {
                sharedInstance.moc.deleteObject(result)
                removed = true
            }
        }
        
        return removed
    }
    
}