//
//  DWKeynoteView.swift
//  erPlay
//
//  Created by Trinity on 16/7/30.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

@IBDesignable class DWKeynoteView: UIView {
    var nextImage: (() -> UIImage?)?
    
    private var _curr = -1
    private var playing = false
    
    /// where the Keynote is playing keynote (read-only)
    var isPlaying: Bool { return playing }
    
    private var curr: UIImageView? {
        get {
            return twoImageViews?[_curr]
        }
    }
    
    private var next: UIImageView? {
        get {
            return twoImageViews?[1 - _curr]
        }
    }
    
    func take() {
        guard let curr = curr else {
            return
        }
        guard let next = next else {
            return
        }
        
        sendSubviewToBack(curr)
        weak var t_curr = curr
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            let img = self?.nextImage?()
            dispatch_async(dispatch_get_main_queue(), {
                t_curr?.image = img
            })
        }
        
        curr.layer.removeAllAnimations()
        next.layer.addAnimation(keynoteAnimation(), forKey: nil)
        
        _curr = 1 - _curr
    }
    
    private var _twoImageViews: [UIImageView]?
    var twoImageViews: [UIImageView]? {
        get {
            if _twoImageViews == nil {
                _twoImageViews = [UIImageView(), UIImageView()]
                _twoImageViews?.forEach({ (imgView) in
                    imgView.frame = bounds
                    imgView.contentMode = .ScaleAspectFill
                    addSubview(imgView)
                })
            }
            return _twoImageViews
        }
    }
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadComponent()
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadComponent()
        configure()
    }
    
    init() {
        super.init(frame: CGRectZero)
        loadComponent()
        configure()
    }
    
    init(withHandler: () -> UIImage) {
        super.init(frame: CGRectZero)
        nextImage = withHandler
        
        loadComponent()
        configure()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    // MARK: - UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        twoImageViews?.forEach { (imgView) in
            imgView.frame = bounds
        }
    }
    
    // MARK: - Set Handler
    func setHandler(handler: () -> UIImage?) {
        nextImage = handler
    }
    
    // MARK: - Action
    
    // MARK: - Other
    func loadComponent() {
        twoImageViews
    }
    
    func configure() {
        backgroundColor = UIColor.clearColor()
        clipsToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: nil) { [weak self] (notif) in
            self?.stop()
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: nil) { [weak self] (notif) in
            self?.replay()
        }
    }
    
    func stop() {
        guard playing else {
            return
        }
        
        twoImageViews?.forEach({ (imgView) in
            imgView.layer.removeAllAnimations()
        })
    }
    
    func replay() {
        guard playing else {
            play()
            return
        }
        
        stop()
        take()
    }
    
    func play() {
        guard !playing else { return }
        playing = true
        
        _curr = 0
        
        guard let curr = curr else{
            return
        }
        
        twoImageViews?.forEach({ (imgView) in
            imgView.image = nextImage?()
        })
        
        bringSubviewToFront(curr)
        curr.layer.addAnimation(keynoteAnimation(), forKey: nil)
    }
    
    private func keynoteAnimation() -> CAAnimationGroup {
        let anis = CAAnimationGroup()
        
        let ani1 = CABasicAnimation(keyPath: "opacity")
        ani1.toValue = 0
        
        let ani2 = CABasicAnimation(keyPath: "transform")
        var t = CATransform3DIdentity
        t = CATransform3DScale(t, 2, 2, 1)
        let alpha = CGFloat(arc4random()) / CGFloat(UInt32.max) * CGFloat(M_PI) * 2
        let radius =  CGFloat(arc4random()) / CGFloat(UInt32.max) * CGFloat(min(bounds.width, bounds.height) / 4)
        t = CATransform3DTranslate(t, radius * sin(alpha), radius * cos(alpha), 0)
        ani2.toValue = NSValue(CATransform3D: t)
        
        anis.animations = [ani1, ani2]
        anis.duration = 3
        anis.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        anis.removedOnCompletion = false
        anis.fillMode = kCAFillModeForwards
        anis.delegate = self
        
        return anis
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        twoImageViews?.forEach { (imgView) in
            imgView.layer.removeAllAnimations()
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        guard flag else {
            return
        }
        take()
    }
}































