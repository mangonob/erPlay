//
//  DWVedioButton.swift
//  SwiftSingleView
//
//  Created by Trinity on 16/7/14.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

@IBDesignable class DWVedioButton: UIButton {
    @IBInspectable var playImage: UIImage? { didSet { updateImage() } }
    @IBInspectable var stopImage: UIImage? { didSet { updateImage() } }
    @IBInspectable var allowFlip: Bool = true
    
    var playing: Bool = true {
        didSet {
            if allowFlip {
                animateToFlip()
            } else {
                updateImage()
            }
        }
    }
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doSomeSetup()
    }
    
    init() {
        super.init(frame: CGRectZero)
        doSomeSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doSomeSetup()
    }

    // MARK: - Animation
    
    func animateToFlip() {
        let flip = CABasicAnimation(keyPath: "transform")
        var t = CATransform3DIdentity
        t.m34 = 1/1000.0
        t = CATransform3DRotate(t, CGFloat(M_PI) * (playing ? 0.5 : 1.5), 0, 1, 0)
        
        flip.duration = 0.15
        flip.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        flip.fromValue = NSValue(CATransform3D: imageView!.layer.transform)
        flip.toValue = NSValue(CATransform3D: t)
        flip.delegate = self
        imageView?.layer.addAnimation(flip, forKey: nil)
        imageView?.layer.transform = t
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        updateImage()
        
        let flip = CABasicAnimation(keyPath: "transform")
        var t = CATransform3DIdentity
        t.m34 = 1/1000.0
        t = CATransform3DRotate(t, CGFloat(M_PI) * (playing ? 1.0 : 2.0), 0, 1, 0)
        
        flip.duration = 0.15
        flip.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        flip.fromValue = NSValue(CATransform3D: imageView!.layer.transform)
        flip.toValue = NSValue(CATransform3D: t)
        
        imageView?.layer.addAnimation(flip, forKey: nil)
        imageView?.layer.transform = t
    }
    
    // MARK: - Other
    func doSomeSetup() {
        setTitle("", forState: UIControlState.Normal)
        setImage(playImage, forState: UIControlState.Normal)
    }
    
    func updateImage() {
        if playing {
            setImage(playImage, forState: UIControlState.Normal)
        } else {
            setImage(stopImage, forState: UIControlState.Normal)
        }
    }
    

}
