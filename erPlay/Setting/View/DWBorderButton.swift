//
//  DWBorderButton.swift
//  SwiftTest
//
//  Created by Trinity on 16/7/22.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWBorderButton: UIButton {
    var borderHidden: Bool = true
    lazy private var kLayer = CAShapeLayer()
    
    // MARK: - Init
    var borderColor: UIColor? {
        didSet {
            kLayer.strokeColor = borderColor?.CGColor
        }
    }
    var borderWidth: CGFloat? {
        didSet {
            kLayer.lineWidth = borderWidth!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init() {
        super.init(frame: CGRectZero)
        configure()
    }

    
    func setBorderHidden(hidden: Bool, animated: Bool) {
        borderHidden = hidden
        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        CATransaction.setAnimationDuration(0.3)
        if hidden {
            kLayer.strokeStart = 0
            kLayer.strokeEnd = 0
        } else {
            kLayer.strokeStart = 0
            kLayer.strokeEnd = 1
        }
        CATransaction.commit()
    }
    
    // MARK: - Other
    func configure() {
        backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        
        kLayer.strokeStart = 0
        kLayer.strokeEnd = 0
        kLayer.lineCap = kCALineCapRound
        kLayer.lineJoin = kCALineJoinRound
        kLayer.lineWidth = borderWidth ?? 2
        kLayer.fillColor = UIColor.clearColor().CGColor
        kLayer.strokeColor = borderColor?.CGColor ?? UIColor.greenColor().CGColor
        kLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: min(bounds.width, bounds.height) / 2).CGPath
        
        layer.addSublayer(kLayer)
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        
        setBorderHidden(true, animated: false)
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: min(bounds.width, bounds.height) / 2)
        kLayer.path = path.CGPath
    }
}
