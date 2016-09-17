//
//  DWERVedioController.swift
//  erPlay
//
//  Created by Trinity on 16/8/4.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit
import AVFoundation

class DWERVedioController: DWVedioController {
    var preference = SettingAccesser()
    var history = HistoryAccesser()
    
    override var themeColor: UIColor {
        return preference.getThemeColor(preference[NSIndexPath(forRow: 0, inSection: 0)] as? Int ?? 0) ?? UIColor.whiteColor()
    }
    
    override var url: NSURL? {
        didSet {
            super.url = url
            if let isPlayFromLeast = preference[NSIndexPath(forRow: 1, inSection: 1)] as? Bool where isPlayFromLeast {
                progress = history.getProgress(url)
            }
        }
    }
    
    var urls: [NSURL?]?
    
    // MARK: - UIViewDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longpressAction(_:)))
        
        let tSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(twoSwipeRight(_:)))
        tSwipeRight.numberOfTouchesRequired = 2
        tSwipeRight.direction = .Right
        
        let tSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(twoSwipeLeft(_:)))
        tSwipeLeft.requireGestureRecognizerToFail(tSwipeRight)
        tSwipeLeft.numberOfTouchesRequired = 2
        tSwipeLeft.direction = .Left
        
        let pan = container.gestureRecognizers?.filter({ (ges) -> Bool in
            return ges.isMemberOfClass(UIPanGestureRecognizer)
        }).first
        pan?.requireGestureRecognizerToFail(tSwipeLeft)
        pan?.requireGestureRecognizerToFail(tSwipeRight)
        
        container.addGestureRecognizer(longPress)
        container.addGestureRecognizer(tSwipeRight)
        container.addGestureRecognizer(tSwipeLeft)
    }
    
    override func doneAction(sender: UIButton) {
        history.addHistory(url)
        history.addProgress(url, progress: progress)
        super.doneAction(sender)
    }
    
    override func doubleTapOnContainer(doubleTap: UITapGestureRecognizer) {
        let enable = preference[NSIndexPath(forRow: 1, inSection: 2)] as? Bool ?? false
        if enable {
            super.doubleTapOnContainer(doubleTap)
        }
    }
    
    // MARK: - Action
    func longpressAction(longPress: UILongPressGestureRecognizer) {
        let enable = preference[NSIndexPath(forRow: 0, inSection: 2)] as? Bool ?? false
        if enable && longPress.state == .Began {
            if !locked {
                locked = true
                setBarHidden(true, animated: true)
                setLockerHidden(true, animated: true)
            } else {
                locked = false
                setBarHidden(false, animated: true)
                setLockerHidden(false, animated: true)
            }
        }
    }
    
    func twoSwipeRight(swipe: UISwipeGestureRecognizer) {
        let enable = preference[NSIndexPath(forRow: 2, inSection: 2)] as? Bool ?? false
        if !enable { return }
        
    }
    
    func twoSwipeLeft(swipe: UISwipeGestureRecognizer) {
        let enable = preference[NSIndexPath(forRow: 3, inSection: 2)] as? Bool ?? false
        if !enable { return }
    }
}



















