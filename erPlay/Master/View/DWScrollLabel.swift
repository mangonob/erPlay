//
//  DWScrollLabel.swift
//  SwiftTest
//
//  Created by Trinity on 16/7/22.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWScrollLabel: UIView {
    lazy var textLabel: UILabel = UILabel()
    
    var speed: CGFloat? { didSet { update() } }
    
    var header: String? { didSet { update() } }
    var tail: String? { didSet { update() } }
    
    var text: String? {
        didSet {
            update()
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
    
    init(){
        super.init(frame: CGRectZero)
        configure()
    }
    
    // MARK: - Other
    func configure() {
        clipsToBounds = true
        
        addSubview(textLabel)
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = .Center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateText() {
        let hd = header ?? " "
        let t = text ?? ""
        let tl = tail ?? " "
        textLabel.text = "\(hd)\(t)\(tl)"
        textLabel.sizeToFit()
    }
    
    func update() {
        //removeConstraints(constraints)
        removeConstraints(constraints.filter({ (constraints) -> Bool in
            return constraints.firstItem === self.textLabel
        }))
        
        updateText()
        textLabel.layer.removeAllAnimations()
        
        let len = textLabel.bounds.width - bounds.width
        
        if len <= 0 {
            addConstraints([
                NSLayoutConstraint(item: textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0),
                ])
            return
        }
        
        addConstraints([
            NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: textLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0),
            ])
        
        let ani = CAKeyframeAnimation(keyPath: "transform.translation.x")
        ani.values = [0, -len, 0]
        ani.keyTimes = [0, 0.98, 1]
        ani.repeatCount = Float.infinity
        let speed = self.speed ?? 30
        
        if speed <= 0 { return }
        
        ani.duration = CFTimeInterval(len / speed / 0.98)
        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        ani.removedOnCompletion = false
        
        textLabel.layer.addAnimation(ani, forKey: nil)
    }
    
    override func layoutSubviews() {
        update()
    }
}















