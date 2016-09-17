//
//  DWHistoryThumbView.swift
//  erPlay
//
//  Created by Trinity on 16/7/28.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

@IBDesignable class DWHistoryThumbView: UIView {
    @IBInspectable var progress: Float = 0.618
    
    var borderWidth: CGFloat = 3 {
        didSet {
            updateBounds()
        }
    }
    
    var borderColor: UIColor = UIColor.dwLightishGreenColor() {
        didSet {
            kLayer.strokeColor = borderColor.CGColor
        }
    }
    
    var image = UIImage() {
        didSet {
            kImageView.image = image
        }
    }
    
    var borderHidden: Bool = false
    // MARK: - Lazy
    var _kLayer: CAShapeLayer!
    var kLayer: CAShapeLayer {
        get {
            if _kLayer == nil {
                _kLayer = CAShapeLayer()
                _kLayer.fillColor = UIColor.clearColor().CGColor
                _kLayer.lineWidth = borderWidth
                _kLayer.lineCap = kCALineCapRound
                _kLayer.strokeColor = borderColor.CGColor
                _kLayer.strokeStart = 0
                _kLayer.strokeEnd = 0
            }
            return _kLayer
        }
    }
    
    private var kImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        return iv
    }()
    
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
    
    deinit {
        removeObserver(self, forKeyPath: "bounds")
    }
    
    // MARK: - Action
//    func tapOn(sender: UITapGestureRecognizer) {
//        setBorderHidden(!borderHidden, animated: true)
//    }
    
    // MARK: - Other
    func configure() {
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
        addObserver(self, forKeyPath: "bounds", options: .New, context: nil)
        
        kImageView.image = image
        addSubview(kImageView)
        
        kImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: kImageView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kImageView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kImageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0),
        ])
        
        kLayer.strokeColor = borderColor.CGColor
        layer.addSublayer(kLayer)
        
        updateBounds()
        setBorderHidden(true, animated: false)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
//        addGestureRecognizer(tap)
    }
    
    func updateBounds() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        
        let path = UIBezierPath(ovalInRect: CGRectInset(bounds, +borderWidth/2, +borderWidth/2))
        kLayer.path = path.CGPath
    }
    
    func setBorderHidden(hidden: Bool, animated: Bool) {
        borderHidden = hidden
        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        CATransaction.setAnimationDuration(0.6)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        if hidden {
            kLayer.strokeStart = 0
            kLayer.strokeEnd = 0
        } else {
            kLayer.strokeStart = 0
            kLayer.strokeEnd = CGFloat(progress)
        }
        CATransaction.commit()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object === self && keyPath! == "bounds" {
            updateBounds()
        }
    }
}































