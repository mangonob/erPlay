//
//  DWCheckBox.swift
//  SwiftTest
//
//  Created by Trinity on 16/7/23.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

@IBDesignable class DWCheckBox: UIButton {
    @IBInspectable var interactionMargin: CGFloat = 0
    
    var kHook: AnyObject?
    
    var checked: Bool = false
    
    private lazy var kBorderLayer: CAShapeLayer = CAShapeLayer()
    private lazy var kCheckLayer: CAShapeLayer = CAShapeLayer()
    
    var borderColor: UIColor? {
        didSet {
            kBorderLayer.strokeColor = borderColor?.CGColor
        }
    }
    
    var borderWidth: CGFloat? {
        didSet {
            kBorderLayer.lineWidth = borderWidth!
        }
    }
    
    var checkColor: UIColor? {
        didSet {
            kCheckLayer.strokeColor = checkColor?.CGColor
        }
    }
    
    var checkWidth: CGFloat? {
        didSet {
            kCheckLayer.lineWidth = checkWidth!
        }
    }
    
    
    // MARK: - Init
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

    // MARK: - Aniamtion
    func setChecked(checked: Bool, animated: Bool) {
        self.checked = checked
        if !animated {
            if checked {
                kCheckLayer.strokeStart = 0
                kCheckLayer.strokeEnd = 1
                kBorderLayer.strokeStart = 0
                kBorderLayer.strokeEnd = 0
            } else {
                kCheckLayer.strokeStart = 0
                kCheckLayer.strokeEnd = 0
                kBorderLayer.strokeStart = 0
                kBorderLayer.strokeEnd = 1
            }
            return
        }
        
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
        CATransaction.setDisableActions(!animated)
        CATransaction.setAnimationDuration(0.2)
        enabled = false
        CATransaction.setCompletionBlock {
            self.enabled = true
            CATransaction.setDisableActions(!animated)
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.1)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear))
            if checked {
                self.kCheckLayer.strokeStart = 0
                self.kCheckLayer.strokeEnd = 1
            } else {
                self.kBorderLayer.strokeStart = 0
                self.kBorderLayer.strokeEnd = 1
            }
            CATransaction.commit()
        }
        if checked {
            kBorderLayer.strokeStart = 0
            kBorderLayer.strokeEnd = 0
        } else {
            kCheckLayer.strokeStart = 0
            kCheckLayer.strokeEnd = 0
        }
        CATransaction.commit()
    }
    
    // MARK: - Other
    func configure() {
        updatePath()
        backgroundColor = UIColor.clearColor()
        
        kBorderLayer.lineCap = kCALineCapRound
        kBorderLayer.lineJoin = kCALineJoinRound
        kBorderLayer.lineWidth = 2
        kBorderLayer.fillColor = UIColor.clearColor().CGColor
        kBorderLayer.strokeColor = borderColor?.CGColor ?? UIColor.whiteColor().CGColor
        
        kCheckLayer.lineCap = kCALineCapSquare
        kCheckLayer.lineCap = kCALineCapSquare
        kCheckLayer.lineWidth = 4
        kCheckLayer.fillColor = UIColor.clearColor().CGColor
        kCheckLayer.strokeColor = checkColor?.CGColor ?? UIColor.greenColor().CGColor
        
        layer.addSublayer(kBorderLayer)
        layer.addSublayer(kCheckLayer)
        
        setChecked(false, animated: false)
    }
    
    func updatePath() {
        let borderPath = UIBezierPath(rect: bounds)
        let checkPath = UIBezierPath()
        let w = bounds.width
        let h = bounds.height
        checkPath.moveToPoint(CGPoint(x: 4.47/26*w, y: 12.21/26*h))
        checkPath.addLineToPoint(CGPoint(x: 11.47/26*w, y: 19.21/26*h))
        checkPath.addLineToPoint(CGPoint(x: 28.47/26*w, y: 1.21/26*h))
        
        kBorderLayer.path = borderPath.CGPath
        kCheckLayer.path = checkPath.CGPath
    }
    
    override func layoutSubviews() {
        updatePath()
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let r = CGRectInset(bounds, -interactionMargin, -interactionMargin)
        return r.contains(point)
    }
}





































