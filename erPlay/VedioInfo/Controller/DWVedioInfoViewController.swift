//
//  DWVedioInfoViewController.swift
//  erPlay
//
//  Created by Trinity on 16/7/30.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWVedioInfoViewController: UIViewController, DWDetailViewController, UIAlertViewDelegate {
    // MARK: - Properties
    var url: NSURL? {
        didSet {
            keynote.setHandler { [weak self] () -> UIImage? in
                return self?.url?.randThumbnail()
            }
        }
    }
    
    // MARK: - Setter and Getter
    var _containerViewController: DWTaaskyContainerViewController?
    var containerViewController: DWTaaskyContainerViewController? {
        get {
            return _containerViewController
        }
        set {
            _containerViewController = newValue
        }
    }
    
    // MARK: - Lazy
    private var _keynote: DWKeynoteView!
    var keynote: DWKeynoteView {
        get {
            if _keynote  == nil {
                _keynote = DWKeynoteView()
                _keynote.nextImage = nil
                
                view.addSubview(_keynote)
                
                _keynote.translatesAutoresizingMaskIntoConstraints = false
                view.addConstraints([
                    NSLayoutConstraint(item: _keynote, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: _keynote, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: _keynote, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: _keynote, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
                    ])
            }
            return _keynote
        }
    }
    
    private var _layoutBetweenPlayButtonAndDeleteButton: UIView!
    private var layoutBetweenPlayButtonAndDeleteButton: UIView {
        get {
            if _layoutBetweenPlayButtonAndDeleteButton == nil {
                _layoutBetweenPlayButtonAndDeleteButton = UIView()
                
                view.insertSubview(_layoutBetweenPlayButtonAndDeleteButton, atIndex: 0)
                
                _layoutBetweenPlayButtonAndDeleteButton.translatesAutoresizingMaskIntoConstraints = false
                view.addConstraints([
                    NSLayoutConstraint(item: _layoutBetweenPlayButtonAndDeleteButton, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.618 * 0.618, constant: 0),
                    NSLayoutConstraint(item: _layoutBetweenPlayButtonAndDeleteButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.618, constant: 0),
                    NSLayoutConstraint(item: _layoutBetweenPlayButtonAndDeleteButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: _layoutBetweenPlayButtonAndDeleteButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0),
                    ])
            }
            return _layoutBetweenPlayButtonAndDeleteButton
        }
    }
    private var _playButton: UIButton!
    var playButton: UIButton {
        get {
            if _playButton == nil {
                _playButton = UIButton()
                
                _playButton.setImage(UIImage(named: "playButton"), forState: .Normal)
                _playButton.addTarget(self, action: #selector(playAction(_:)), forControlEvents: .TouchUpInside)
                
                view.addSubview(_playButton)
                
                _playButton.translatesAutoresizingMaskIntoConstraints = false
                view.addConstraints([
                    NSLayoutConstraint(item: _playButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60),
                    NSLayoutConstraint(item: _playButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60),
                    NSLayoutConstraint(item: _playButton, attribute: .Left, relatedBy: .Equal, toItem: layoutBetweenPlayButtonAndDeleteButton, attribute: .Left, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: _playButton, attribute: .CenterY, relatedBy: .Equal, toItem: layoutBetweenPlayButtonAndDeleteButton, attribute: .CenterY, multiplier: 1, constant: 0),
                    ])
                
                let label : UILabel = {
                    let label = UILabel()
                    label.attributedText = NSAttributedString(string: "Play", attributes: [
                        NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 20)!,
                        NSKernAttributeName: 1.17,
                        NSForegroundColorAttributeName: UIColor.whiteColor()
                        ])
                    label.sizeToFit()
                    return label
                }()
                
                view.addSubview(label)
                
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addConstraints([
                    NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: _playButton, attribute: .CenterX, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: _playButton, attribute: .Bottom, multiplier: 1, constant: 12),
                    ])
            }
            return _playButton
        }
    }
    
    private var _deleteButton: UIButton!
    var deleteButton: UIButton {
        get {
            if _deleteButton == nil {
                _deleteButton = UIButton()
                _deleteButton.setImage(UIImage(named: "deleteButton"), forState: .Normal)
                _deleteButton.addTarget(self, action: #selector(deleteAction(_:)), forControlEvents: .TouchUpInside)
                
                view.addSubview(_deleteButton)
                
                _deleteButton.translatesAutoresizingMaskIntoConstraints = false
                view.addConstraints([
                    NSLayoutConstraint(item: _deleteButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60),
                    NSLayoutConstraint(item: _deleteButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60),
                    NSLayoutConstraint(item: _deleteButton, attribute: .Right, relatedBy: .Equal, toItem: layoutBetweenPlayButtonAndDeleteButton, attribute: .Right, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: _deleteButton, attribute: .CenterY, relatedBy: .Equal, toItem: layoutBetweenPlayButtonAndDeleteButton, attribute: .CenterY, multiplier: 1, constant: 0),
                    ])
                
                let label : UILabel = {
                    let label = UILabel()
                    label.attributedText = NSAttributedString(string: "Delete", attributes: [
                        NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 20)!,
                        NSKernAttributeName: 1.17,
                        NSForegroundColorAttributeName: UIColor.dwGrapefruitColor()
                        ])
                    return label
                }()
                
                view.addSubview(label)
                
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addConstraints([
                    NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: _deleteButton, attribute: .CenterX, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: _deleteButton, attribute: .Bottom, multiplier: 1, constant: 12),
                    ])
            }
            return _deleteButton
        }
    }
    
    
    // MARK: - UIViewDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.dwBrownishGreyColor()
        
        keynote
        playButton
        deleteButton
        layoutBetweenPlayButtonAndDeleteButton
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keynote.stop()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        keynote.replay()
    }
    
    // MARK: - AlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            if let url = url {
                HistoryAccesser().removeHistory(url)
                HistoryAccesser().removeProgress(url)
                let _ = try? NSFileManager.defaultManager().removeItemAtURL(url)
                containerViewController?.masterViewController?.getUrlsAtDirectory()
                containerViewController?.masterViewController?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Action
    func playAction(sender: UIButton) {
        let vedioVc = DWERVedioController()
        vedioVc.url = url
        vedioVc.setDone { [weak vedioVc] in
            vedioVc?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        vedioVc.modalTransitionStyle = .FlipHorizontal
        
        containerViewController?.presentViewController(vedioVc, animated: true, completion: nil)
    }
    
    func deleteAction(sender: UIButton) {
        if let url = url {
            let alert = UIAlertView(title: "Warnning", message: "Are you sure delete \(url.lastPathComponent ?? "UNTITLED")", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
            alert.show()
        }
    }
}

































