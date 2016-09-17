//
//  SettingAccesser.swift
//  erPlay
//
//  Created by Trinity on 16/7/26.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import Foundation
import UIKit

class SettingAccesser: NSObject {
    lazy var map: NSArray? = {
        let path = NSBundle.mainBundle().pathForResource("defaultSetting", ofType: "plist")
        if let path = path {
            return NSArray(contentsOfFile: path)
        }
        return nil
    }()
    
    subscript(indexPath: NSIndexPath) -> AnyObject? {
        set {
            let key = keyAtIndexPath(indexPath)
            if let key = key {
                NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: key)
            }
        }
        
        get {
            let key = keyAtIndexPath(indexPath)
            if let key = key {
                return NSUserDefaults.standardUserDefaults().valueForKey(key)
            }
            return nil
        }
    }
    
    func tryToDefault() {
        let sections = map
        sections?.forEach({ (section) in
            if let rows = section as? NSArray {
                rows.forEach({ (row) in
                    if let dict = row as? NSDictionary {
                        if let key = dict.allKeys.first as? String, value = dict.allValues.first {
                            if NSUserDefaults.standardUserDefaults().valueForKey(key) == nil {
                                NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
                            }
                        }
                    }
                })
            }
        })
    }
    
    func getThemeColor(index: Int) -> UIColor? {
        let colors = [
            UIColor.dwReddishPinkColor(),
            UIColor.whiteColor(),
            UIColor.blackColor(),
            ]
        guard index >= 0 && index < colors.count else {
            return nil
        }
        return colors[index]
    }
    
    // MARK: - Other
    private func valueAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        let dict = (map?[indexPath.section] as? NSArray)?[indexPath.row] as? NSDictionary
        if let key = dict?.allKeys.first as? String {
            return dict?[key]
        }
        return nil
    }
    
    private func keyAtIndexPath(indexPath: NSIndexPath) -> String? {
        let dict = (map?[indexPath.section] as? NSArray)?[indexPath.row] as? NSDictionary
        return dict?.allKeys.first as? String
    }
}
