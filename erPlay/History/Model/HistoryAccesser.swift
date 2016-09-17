//
//  HistoryAccesser.swift
//  erPlay
//
//  Created by Trinity on 16/7/28.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class HistoryAccesser: NSObject {
    private let historyKeyWord = "3cd15f8f2940aff879df34df4e5c2cd1"
    private let progressKeyWord = "8451fc653eaa269664a6d9b46a238424"
    
    var items: [(url:NSURL?, date:NSDate?)]? {
        return histories.sort({ (a, b) -> Bool in
            if let a = a.value as? NSDate, b = b.value as? NSDate {
                if a.compare(b) == .OrderedAscending {
                    return true
                }
            }
            return false
        }).map({ (elem) -> (url:NSURL?, date:NSDate?) in
            guard let dir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first else {
                fatalError("I can't get document directory")
            }
            
            return (url: dir.URLByAppendingPathComponent(elem.key as? String ?? ""), date: elem.value as? NSDate)
        })
    }
    
    var histories: NSMutableDictionary {
        return (NSUserDefaults.standardUserDefaults().valueForKey(historyKeyWord) as? NSDictionary ?? NSDictionary()).mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
    }
    var progresses: NSMutableDictionary {
        return (NSUserDefaults.standardUserDefaults().valueForKey(progressKeyWord) as? NSDictionary ?? NSDictionary()).mutableCopy() as? NSMutableDictionary ?? NSMutableDictionary()
    }
    
    func addHistory(url: NSURL?) {
        if let key = url?.relativeAboutDocuments() {
            let his = histories
            his[key] = NSDate()
            NSUserDefaults.standardUserDefaults().setValue(his, forKey: historyKeyWord)
        }
    }
    
    func getHistory(url: NSURL?) -> NSDate? {
        if let key = url?.relativeAboutDocuments() {
            return histories[key] as? NSDate
        }
        return nil
    }
    
    func removeHistory(url: NSURL?) {
        if let key = url?.relativeAboutDocuments() {
            let his = histories
            his[key] = nil
            NSUserDefaults.standardUserDefaults().setValue(his, forKey: historyKeyWord)
        }
    }
    
    func addProgress(url: NSURL?, progress: Double) {
        if let key = url?.relativeAboutDocuments() {
            let prs = progresses
            prs[key] = progress
            NSUserDefaults.standardUserDefaults().setValue(prs, forKey: progressKeyWord)
        }
    }
    
    func getProgress(url: NSURL?) -> Double {
        if let key = url?.relativeAboutDocuments() {
            return progresses[key] as? Double ?? 0
        }
        return 0
    }
    
    func removeProgress(url: NSURL?) {
        if let key = url?.relativeAboutDocuments() {
            let prs = progresses
            prs[key] = nil
            NSUserDefaults.standardUserDefaults().setValue(prs, forKey: progressKeyWord)
        }
    }
    
    func clearAll() {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: historyKeyWord)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: progressKeyWord)
    }
}
