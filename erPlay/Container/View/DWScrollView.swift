//
//  DWScrollView.swift
//  erPlay
//
//  Created by Trinity on 16/7/28.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWScrollView: UIScrollView {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        guard let hit = super.hitTest(point, withEvent: event) else {
            return nil
        }
        
        scrollEnabled = !hit.isMemberOfClass(UISlider)
        
        return hit
    }
}
