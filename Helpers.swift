//
//  Helpers.swift
//  ApplePoker
//
//  Created by Morgan Wilde on 20/12/2014.
//  Copyright (c) 2014 Morgan Wilde. All rights reserved.
//

import Foundation
import CoreData

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        var error: NSError?
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        return matches.count > 0
    }
    
}

extension String {
    func removeSpaces() -> String {
        let newString = self.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        return newString
    }
    
    func contains(pattern: String) -> Int? {
        let regex = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: nil)!
        let theCount = regex.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: count(self)))
        if theCount > 0 {
            return theCount
        } else {
            return nil
        }
    }
}
