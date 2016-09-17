//
//  Utilities.swift
//  GooeySlider
//
//  Created by Trinity on 16/7/4.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import Foundation
import UIKit

func RGB(r: Int, _ g: Int, _ b: Int) -> UIColor {
    return UIColor(colorLiteralRed: Float(r)/255.0,
                   green: Float(g)/255.0,
                   blue: Float(b)/255.0,
                   alpha: 1.0)
}


func RGBA(r: Int, _ g: Int, _ b: Int, _ alpha: Float) -> UIColor {
    return UIColor(colorLiteralRed: Float(r)/255.0,
                   green: Float(g)/255.0,
                   blue: Float(b)/255.0,
                   alpha: alpha)
}
