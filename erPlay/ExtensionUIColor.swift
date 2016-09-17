//
//  ExtensionUIColor.swift
//  Demo
//
//  Created by Trinity on 16/7/15.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(colorArray array: NSArray) {
        let r = array[0] as! CGFloat / 255.0
        let g = array[1] as! CGFloat / 255.0
        let b = array[2] as! CGFloat / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    convenience init(colorDictionary dict: NSDictionary) {
        let r = CGFloat((dict["r"] as! NSNumber).floatValue / 255.0)
        let g = CGFloat((dict["g"] as! NSNumber).floatValue / 255.0)
        let b = CGFloat((dict["b"] as! NSNumber).floatValue / 255.0)
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
