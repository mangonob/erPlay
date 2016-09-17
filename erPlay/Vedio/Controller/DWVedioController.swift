//
//  ViewController.swift
//  SwiftSingleView
//
//  Created by Trinity on 16/6/1.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class DWVedioController: UIViewController {
    
    var themeColor: UIColor {
        return view.tintColor
    }
    
    var url: NSURL? {
        didSet {
            guard let url = url else {
                return
            }
            
            let item = AVPlayerItem(URL: url)
            player.replaceCurrentItemWithPlayerItem(item)
        }
    }
    
    // MARK: - Compoments
    private var doneBlk: (() -> Void)?
    
    var container: UIView!
    var pLayer: AVPlayerLayer!
    
    var topBar: UIView!
    var doneButton: UIButton!
    
    var bottomBar: UIView!
    var button: DWVedioButton!
    var progresser: UIProgressView!
    var progresserForegroundView: UIView = UIView()
    var leftTime: UILabel!
    var rightTime: UILabel!
    
    var leftView: UIView!
    var lockButton: UIButton!
    
    var centerTimeLine: UILabel!
    
    var locked: Bool = false {
        didSet {
            if locked {
                lockButton.setImage(UIImage(named: "lock")?.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
            } else {
                lockButton.setImage(UIImage(named: "unlock")?.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
            }
        }
    }
    
    var rightView: UIView!
    var speedLabel: UILabel!
    var fastButton: UIButton!
    var slowButton: UIButton!
    
    // MARK: - Gestures
    private var panOnContainer: UIPanGestureRecognizer?
    
    // MARK: - Properties
    var barHidden: Bool = false
    var lockerHidden: Bool = false
    var timeHidden: Bool = false
    
    private var customSpeed: Float = 1.00
    
    var _player: AVPlayer!
    var player: AVPlayer {
        get {
            if _player == nil {
                _player = AVPlayer()
            }
            return _player
        }
    }
    
    var tProgress: Double = 0
    var tPlaying: Bool = false
    var _progress: Double = 0
    var progress: Double {
        get {
            guard let url = url else {
                return 0
            }
            let ass = AVURLAsset(URL: url)
            let sec = ass.duration.seconds
            let curr = player.currentTime().seconds
            return curr / sec
        }
        set {
            guard let url = url else {
                return
            }
            let ass = AVURLAsset(URL: url)
            let sec = ass.duration.seconds
            let cTime = CMTime(seconds: newValue * sec, preferredTimescale: ass.duration.timescale)
            player.seekToTime(cTime, toleranceBefore: CMTime(value: 1, timescale: 2), toleranceAfter: CMTime(value: 1, timescale: 2))
        }
    }
    
    // MARK: - Init
    
    deinit {
        container.removeObserver(self, forKeyPath: "bounds")
    }
    
    // MARK: - UIView
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func shouldAutorotate() -> Bool {
        return !locked
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = DWContainerView()
        pLayer = AVPlayerLayer(player: player)
        
        container.backgroundColor = UIColor.blackColor()
        container.layer.insertSublayer(pLayer, atIndex: 0)
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            NSLayoutConstraint(item: container, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: container, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0),
            ])
        
        pLayer.frame = container.bounds
        
        layoutTopBar()
        layoutBottomBar()
        layoutLeft()
        layoutRight()
        layoutCenter()
        
        container.addObserver(self, forKeyPath: "bounds", options: [.New, .Old], context: nil)
        
        player.addPeriodicTimeObserverForInterval(CMTime(value: 1, timescale: 10), queue: nil,
                                                  usingBlock: { [weak self] (time) in
                                                    guard let _self = self else {
                                                        return
                                                    }
                                                    _self.progresser.progress =
                                                        Float(_self.player.currentTime().seconds / (_self.player.currentItem?.duration.seconds)!)
                                                    _self.updateTimeLine()
            })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(enterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        prepareGesture()
        prepareTarget()
        
        setBottomTimeHidden(interfaceOrientation == .Portrait || interfaceOrientation == .PortraitUpsideDown)
        setTimeHidden(true, animated: false)
        
        setBarHidden(true, animated: false)
        setLockerHidden(true, animated: false)
        
        play()
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        setBottomTimeHidden(toInterfaceOrientation == .Portrait || toInterfaceOrientation == .PortraitUpsideDown)
    }
    
    // MARK: - Action
    func pauseButton(sender: DWVedioButton) {
        if sender.playing {
            pause()
        } else {
            play()
        }
    }
    
    func tapContainerView (tap: UITapGestureRecognizer?) {
        if !locked {
            setBarHidden(!barHidden, animated: true)
        }
        setLockerHidden(!lockerHidden, animated: true)
        setTimeHidden(true, animated: true)
    }
    
    func lockAndUnlockAction(sender: UIButton) {
        locked = !locked
        if locked {
            setBarHidden(true, animated: true)
        } else {
            setBarHidden(false, animated: true)
        }
    }
    
    func slideOnProgresser(sender: UIPanGestureRecognizer) {
        if locked {
            return
        }
        switch sender.state {
        case .Began:
            tPlaying = false
            
            let radius = progresserForegroundView.bounds.height / 2
            let cnter = CGRect(x: progresserForegroundView.bounds.width * CGFloat(progress), y: radius, width: 0, height: 0)
            let mainRect = CGRectInset(cnter, -radius * 2, -radius)
            if !CGRectContainsPoint(mainRect, sender.locationInView(progresserForegroundView)) {
                sender.enabled = false
                sender.enabled = true
            } else {
                setTimeHidden(false, animated: true)
                tPlaying = button.playing
                if button.playing {
                    pause()
                }
                tProgress = progress
            }
        case .Changed:
            let delta = Double(sender.translationInView(progresserForegroundView).x / progresserForegroundView.bounds.width)
            progress = min(max(tProgress + delta, 0), 1)
        case .Ended, .Cancelled, .Failed:
            setTimeHidden(true, animated: true)
            if tPlaying {
                play()
            }
        default:
            break
        }
    }
    
    func slideOnContainer(sender: UIPanGestureRecognizer) {
        if locked {
            return
        }
        switch sender.state {
        case .Began:
            tPlaying = button.playing
            if button.playing {
                pause()
            }
            setTimeHidden(false, animated: true)
            tProgress = progress
        case .Changed:
            let delta = Double(sender.translationInView(container).x / container.bounds.width * 0.3)
            progress = min(max(tProgress + delta, 0), 1)
        case .Ended, .Cancelled, .Failed:
            setTimeHidden(true, animated: true)
            if tPlaying {
                play()
            }
        default:
            break
        }
    }
    
    func speedUpAction(sender: UIButton) {
        if locked { return }
        customSpeed = min(2, customSpeed + 0.5)
        if player.rate > 0.1 {
            player.rate = customSpeed
        }
        speedLabel.text = String(format: "x%.1f", customSpeed)
    }
    
    func speedDownAction(sender: UIButton) {
        customSpeed = max(0.5, customSpeed - 0.5)
        if player.rate > 0.1 {
            player.rate = customSpeed
        }
        speedLabel.text = String(format: "x%.1f", customSpeed)
    }
    
    func enterBackground(notification: NSNotification){
        if button.playing {
            pause()
        }
    }
    
    func doubleTapOnContainer(doubleTap: UITapGestureRecognizer) {
        if locked { return }
        if button.playing {
            pause()
        } else {
            play()
        }
    }
    
    // MARK: - Action on Done
    func doneAction(sender: UIButton) {
        doneBlk?()
    }
    
    // MARK: - Control
    
    func pause() {
        player.pause()
        button.playing = false
    }
    
    func play() {
        player.play()
        player.rate = customSpeed
        button.playing = true
    }
    
    // MARK: - Other
    func prepareGesture() {
        let dTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapOnContainer(_:)))
        dTap.numberOfTapsRequired = 2
        container.addGestureRecognizer(dTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapContainerView(_:)))
        tap.requireGestureRecognizerToFail(dTap)
        container.addGestureRecognizer(tap)
        
        
        var pan = UIPanGestureRecognizer(target: self, action: #selector(slideOnProgresser(_:)))
        progresserForegroundView.addGestureRecognizer(pan)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(slideOnContainer(_:)))
        container.addGestureRecognizer(pan)
        panOnContainer = pan
    }
    
    func prepareTarget() {
        button.addTarget(self, action: #selector(pauseButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        lockButton.addTarget(self, action: #selector(lockAndUnlockAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        fastButton.addTarget(self, action: #selector(speedUpAction(_:)), forControlEvents: .TouchUpInside)
        slowButton.addTarget(self, action: #selector(speedDownAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    func setDone(done : (() -> Void)?) {
        doneBlk = done
    }
    
    // MARK: - Just Animation Setter
    func setBarHidden(hidden: Bool, animated: Bool) {
        barHidden = hidden
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        CATransaction.setDisableActions(!animated)
        if barHidden {
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            topBar.alpha = 0
            bottomBar.alpha = 0
            topBar.transform = CGAffineTransformMakeTranslation(0, -topBar.bounds.height)
            bottomBar.transform = CGAffineTransformMakeTranslation(0, bottomBar.bounds.height)
            rightView.alpha = 0
        } else {
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
            topBar.alpha = 1
            bottomBar.alpha = 1
            topBar.transform = CGAffineTransformIdentity
            bottomBar.transform = CGAffineTransformIdentity
            rightView.alpha = 1
        }
        UIView.commitAnimations()
    }
    
    func setLockerHidden(hidden: Bool, animated: Bool) {
        lockerHidden = hidden
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        CATransaction.setDisableActions(!animated)
        if lockerHidden {
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            leftView.alpha = 0
        } else {
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
            leftView.alpha = 1
        }
        UIView.commitAnimations()
    }
    
    func setTimeHidden(hidden: Bool, animated: Bool) {
        timeHidden = hidden
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        CATransaction.setDisableActions(!animated)
        if timeHidden {
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            centerTimeLine.alpha = 0
        } else {
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
            centerTimeLine.alpha = 1
        }
        UIView.commitAnimations()
    }
    
    func setBottomTimeHidden(hidden: Bool) {
        if hidden {
            bottomBar.removeConstraints(bottomBar.constraints.filter({ [weak self] (constraint) -> Bool in
                guard let _self = self else { return false }
                return [_self.leftTime, _self.rightTime, _self.progresser].contains(constraint)
                }))
            
            leftTime.hidden = true
            rightTime.hidden = true
            
            progresser.translatesAutoresizingMaskIntoConstraints = false
            bottomBar.addConstraints([
                NSLayoutConstraint(item: progresser, attribute: .CenterY, relatedBy: .Equal, toItem: bottomBar, attribute: .CenterY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progresser, attribute: .Left, relatedBy: .Equal, toItem: button, attribute: .Right, multiplier: 1, constant: 8),
                NSLayoutConstraint(item: progresser, attribute: .Right, relatedBy: .Equal, toItem: bottomBar, attribute: .Right, multiplier: 1, constant: -8),
                ])
        } else {
            bottomBar.removeConstraints(bottomBar.constraints.filter({ [weak self] (constraint) -> Bool in
                guard let _self = self else { return false }
                return constraint.firstItem === _self.progresser
                }))
            
            
            leftTime.translatesAutoresizingMaskIntoConstraints = false
            rightTime.translatesAutoresizingMaskIntoConstraints = false
            progresser.translatesAutoresizingMaskIntoConstraints = false
            
            bottomBar.addConstraints([
                NSLayoutConstraint(item: leftTime, attribute: .CenterY, relatedBy: .Equal, toItem: bottomBar, attribute: .CenterY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: leftTime, attribute: .Left, relatedBy: .Equal, toItem: button, attribute: .Right, multiplier: 1, constant: 8),
                ])
            bottomBar.addConstraints([
                NSLayoutConstraint(item: progresser, attribute: .CenterY, relatedBy: .Equal, toItem: bottomBar, attribute: .CenterY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progresser, attribute: .Left, relatedBy: .Equal, toItem: leftTime, attribute: .Right, multiplier: 1, constant: 8),
                NSLayoutConstraint(item: progresser, attribute: .Right, relatedBy: .Equal, toItem: rightTime, attribute: .Left, multiplier: 1, constant: -8),
                ])
            bottomBar.addConstraints([
                NSLayoutConstraint(item: rightTime, attribute: .CenterY, relatedBy: .Equal, toItem: bottomBar, attribute: .CenterY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: rightTime, attribute: .Right, relatedBy: .Equal, toItem: bottomBar, attribute: .Right, multiplier: 1, constant: -8),
                ])
            
            leftTime.hidden = false
            rightTime.hidden = false
        }
    }
    
    func updateTimeLine() {
        let a = player.currentTime().seconds ?? 0
        let b = player.currentItem?.duration.seconds ?? 0
        
        centerTimeLine.text = String(format: "%02.0f:%02.0f/%02.0f:%02.0f", a/60, a%60, b/60, b%60)
        leftTime.text = String(format: "%02.0f:%02.0f", a/60, a%60)
        rightTime.text = String(format: "%02.0f:%02.0f", (b-a)/60, (b-a)%60)
    }
    
    // MARK: - Layout Other
    func layoutTopBar () {
        topBar = UIView()
        container.addSubview(topBar)
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        /* consider to topLayoutGuide, the constraints should add to the root view of this controller */
        view.addConstraints([
            NSLayoutConstraint(item: topBar, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topBar, attribute: .Bottom, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 40)
            ])
        container.addConstraints([
            NSLayoutConstraint(item: topBar, attribute: .Left, relatedBy: .Equal, toItem: container, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topBar, attribute: .Right, relatedBy: .Equal, toItem: container, attribute: .Right, multiplier: 1, constant: 0),
            ])
        
        doneButton = UIButton(type: UIButtonType.Custom)
        doneButton.adjustsImageWhenDisabled = true
        doneButton.reversesTitleShadowWhenHighlighted = true
        doneButton.adjustsImageWhenHighlighted = true
        doneButton.showsTouchWhenHighlighted = true
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        
        doneButton.setTitleColor(themeColor, forState: .Normal)
        
        doneButton.addTarget(self, action: #selector(doneAction(_:)), forControlEvents: .TouchUpInside)
        
        topBar.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        topBar.addSubview(doneButton)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addConstraints([
            NSLayoutConstraint(item: doneButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: doneButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60),
            
            NSLayoutConstraint(item: doneButton, attribute: .CenterY, relatedBy: .Equal, toItem: topBar, attribute: .Bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: doneButton, attribute: .Left, relatedBy: .Equal, toItem: topBar, attribute: .Left, multiplier: 1, constant: 8),
            ])
    }
    
    func layoutBottomBar () {
        bottomBar = UIView()
        button = DWVedioButton()
        progresser = UIProgressView()
        leftTime = UILabel()
        rightTime = UILabel()
        
        container.addSubview(bottomBar)
        bottomBar.addSubview(button)
        bottomBar.addSubview(progresser)
        bottomBar.addSubview(leftTime)
        bottomBar.addSubview(rightTime)
        bottomBar.insertSubview(progresserForegroundView, aboveSubview: progresser)
        
        button.playImage = UIImage(named: "stop")?.imageWithRenderingMode(.AlwaysTemplate)
        button.stopImage = UIImage(named: "play")?.imageWithRenderingMode(.AlwaysTemplate)
        button.tintColor = themeColor
        
        bottomBar.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        progresser.tintColor = themeColor
        
        rightTime.font = UIFont.systemFontOfSize(14)
        leftTime.font = UIFont.systemFontOfSize(14)
        rightTime.textColor = themeColor
        leftTime.textColor = themeColor
        rightTime.textAlignment = .Center
        leftTime.textAlignment = .Center
        rightTime.text = "00:00"
        leftTime.text = "00:00"
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints([
            NSLayoutConstraint(item: bottomBar, attribute: .Left, relatedBy: .Equal, toItem: container, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomBar, attribute: .Right, relatedBy: .Equal, toItem: container, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomBar, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        progresser.translatesAutoresizingMaskIntoConstraints = false
        progresserForegroundView.translatesAutoresizingMaskIntoConstraints = false
        
        
        bottomBar.addConstraints([
            NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: bottomBar, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: bottomBar, attribute: .Left, multiplier: 1, constant: 8),
            ])
        
        bottomBar.addConstraints([
            NSLayoutConstraint(item: progresser, attribute: .CenterY, relatedBy: .Equal, toItem: bottomBar, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: progresser, attribute: .Left, relatedBy: .Equal, toItem: button, attribute: .Right, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: progresser, attribute: .Right, relatedBy: .Equal, toItem: bottomBar, attribute: .Right, multiplier: 1, constant: -8),
            ])
        
        bottomBar.addConstraints([
            NSLayoutConstraint(item: progresserForegroundView, attribute: .Width, relatedBy: .Equal, toItem: progresser, attribute: .Width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: progresserForegroundView, attribute: .Height, relatedBy: .Equal, toItem: bottomBar, attribute: .Height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: progresserForegroundView, attribute: .CenterX, relatedBy: .Equal, toItem: progresser, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: progresserForegroundView, attribute: .CenterY, relatedBy: .Equal, toItem: progresser, attribute: .CenterY, multiplier: 1, constant: 0),
            ])
    }
    
    func layoutLeft() {
        leftView = UIView()
        container.addSubview(leftView)
        
        lockButton = UIButton()
        lockButton.setImage(UIImage(named: "unlock")?.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
        lockButton.tintColor = themeColor
        
        leftView.addSubview(lockButton)
        
        leftView.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints([
            NSLayoutConstraint(item: leftView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: leftView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: leftView, attribute: .CenterY, relatedBy: .Equal, toItem: container, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: leftView, attribute: .Left, relatedBy: .Equal, toItem: container, attribute: .Left, multiplier: 1, constant: 4),
            ])
        
        lockButton.translatesAutoresizingMaskIntoConstraints = false
        leftView.addConstraints([
            NSLayoutConstraint(item: lockButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: lockButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: lockButton, attribute: .CenterX, relatedBy: .Equal, toItem: leftView, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: lockButton, attribute: .CenterY, relatedBy: .Equal, toItem: leftView, attribute: .CenterY, multiplier: 1, constant: 0),
            ])
    }
    
    func layoutRight() {
        rightView = UIView()
        container.addSubview(rightView)
        
        rightView.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints([
            NSLayoutConstraint(item: rightView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100),
            NSLayoutConstraint(item: rightView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40),
            NSLayoutConstraint(item: rightView, attribute: .CenterY, relatedBy: .Equal, toItem: container, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rightView, attribute: .Right, relatedBy: .Equal, toItem: container, attribute: .Right, multiplier: 1, constant: 0),
            ])
        
        speedLabel = UILabel()
        fastButton = UIButton()
        slowButton = UIButton()
        
        speedLabel.numberOfLines = 0
        speedLabel.textAlignment = .Center
        speedLabel.textColor = themeColor
        speedLabel.text = "x1.0"
        speedLabel.font = UIFont.systemFontOfSize(16)
        speedLabel.sizeToFit()
        
        fastButton.setImage(UIImage(named: "fast")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        slowButton.setImage(UIImage(named: "slow")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        fastButton.tintColor = themeColor
        slowButton.tintColor = themeColor
        
        rightView.addSubview(fastButton)
        rightView.addSubview(slowButton)
        rightView.addSubview(speedLabel)
        
        fastButton.translatesAutoresizingMaskIntoConstraints = false
        slowButton.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        rightView.addConstraints([
            NSLayoutConstraint(item: speedLabel, attribute: .CenterX, relatedBy: .Equal, toItem: rightView, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: speedLabel, attribute: .CenterY, relatedBy: .Equal, toItem: rightView, attribute: .CenterY, multiplier: 1, constant: 0),
            ])
        
        rightView.addConstraints([
            NSLayoutConstraint(item: fastButton, attribute: .Height, relatedBy: .Equal, toItem: rightView, attribute: .Height, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: fastButton, attribute: .Width, relatedBy: .Equal, toItem: rightView, attribute: .Width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: fastButton, attribute: .Top, relatedBy: .Equal, toItem: rightView, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: fastButton, attribute: .CenterX, relatedBy: .Equal, toItem: rightView, attribute: .CenterX, multiplier: 1, constant: 0),
            ])
        
        rightView.addConstraints([
            NSLayoutConstraint(item: slowButton, attribute: .Height, relatedBy: .Equal, toItem: rightView, attribute: .Height, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: slowButton, attribute: .Width, relatedBy: .Equal, toItem: rightView, attribute: .Width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: slowButton, attribute: .Bottom, relatedBy: .Equal, toItem: rightView, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: slowButton, attribute: .CenterX, relatedBy: .Equal, toItem: rightView, attribute: .CenterX, multiplier: 1, constant: 0),
            ])
    }
    
    func layoutCenter() {
        centerTimeLine = UILabel()
        
        centerTimeLine.numberOfLines = 0
        centerTimeLine.adjustsFontSizeToFitWidth = true
        centerTimeLine.textColor = UIColor.whiteColor()
        centerTimeLine.font = UIFont.systemFontOfSize(30)
        centerTimeLine.text = "00:00/00:00"
        centerTimeLine.textAlignment = .Center
        
        container.addSubview(centerTimeLine)
        
        centerTimeLine.translatesAutoresizingMaskIntoConstraints = false
        container.addConstraints([
            NSLayoutConstraint(item: centerTimeLine, attribute: .CenterX, relatedBy: .Equal, toItem: container, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: centerTimeLine, attribute: .CenterY, relatedBy: .Equal, toItem: container, attribute: .CenterY, multiplier: 1, constant: -60),
            ])
        
        setTimeHidden(true, animated: false)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object === container && keyPath! == "bounds" {
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            )
            CATransaction.setAnimationDuration(0.3)
            pLayer.frame = container.bounds
            CATransaction.commit()
        }
    }
}

class DWContainerView: UIView {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var s = super.hitTest(point, withEvent: event)
        subviews.forEach { (view) in
            if view == s {
                s = nil
            }
        }
        return s
    }
}



























