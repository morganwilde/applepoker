//
//  ServerHelper.swift
//  ApplePoker
//
//  Created by Simas Abramovas on 20/12/14.
//  Copyright (c) 2014 Simas Abramovas. All rights reserved.
//

import Foundation

class ServerHelper {
    
    class var sharedInstance: ServerHelper {
        struct Static {
            static var instance: ServerHelper?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ServerHelper()
        }
        
        return Static.instance!
    }
    
    var queue : NSOperationQueue = NSOperationQueue()
    
    enum CONST : String {
        case ERROR = "error: "
    }
    
    class func urlRemoveUser(id : Int) -> String {
        return "http://applepoker.herokuapp.com/user/\(id)/remove"
    }
    
    class func urlAddUser(name : String) -> String {
        return "http://applepoker.herokuapp.com/user/\(name)/add"
    }
    
    class func urlSetAvatar(userId : Int, avatarId: Int) -> String {
        return "http://applepoker.herokuapp.com/user/\(userId)/update/avatar?url=\(avatarId)"
    }
    
    class func asyncQuery(url: String, callback: ((String) -> ())? = nil) {
        let request: NSURLRequest = NSURLRequest(URL : NSURL(string: url)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue : sharedInstance.queue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let error = error {
                NSException(name: "Network Exception", reason: "Async call failed to url: \(url), with error: \(error)", userInfo: nil).raise()
            } else {
                let dataString = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                callback?(dataString)
            }
        })
    }
    
}