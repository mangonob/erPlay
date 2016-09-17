//
//  DWTaaskyContainerViewController.swift
//  Demo
//
//  Created by Trinity on 16/7/15.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWTaaskyContainerViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var detailContainerViewController: UIViewController?
    
    var masterViewController: DWTaaskyMasterViewController? {
        didSet {
            masterViewController?.containerViewController = self
        }
    }
    
    var detailViewController: DWDetailViewController? {
        didSet {
            if let detailViewController = detailViewController as? UIViewController, detailContainerViewController = detailContainerViewController {
                (oldValue as? UIViewController)?.removeFromParentViewController()
                detailContainerViewController.addChildViewController(detailViewController)
                detailContainerViewController.view.subviews.forEach({ (subView) in
                    subView.removeFromSuperview()
                })
                detailContainerViewController.view.addSubview(detailViewController.view)
                
                detailViewController.view.translatesAutoresizingMaskIntoConstraints = false
                detailContainerViewController.view.addConstraints([
                    NSLayoutConstraint(item: detailViewController.view, attribute: .Left, relatedBy: .Equal, toItem: detailContainerViewController.view, attribute: .Left, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: detailViewController.view, attribute: .Right, relatedBy: .Equal, toItem: detailContainerViewController.view, attribute: .Right, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: detailViewController.view, attribute: .Top, relatedBy: .Equal, toItem: detailContainerViewController.view, attribute: .Top, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: detailViewController.view, attribute: .Bottom, relatedBy: .Equal, toItem: detailContainerViewController.view, attribute: .Bottom, multiplier: 1, constant: 0),
                    ])
            }
            
            detailViewController?.containerViewController = self
        }
    }
    
    var once = dispatch_once_t()
    
    var kHidden: Bool = false
    
    // MARK: - UIViewDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        let hamburger = DWHamburgerView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHamburgerAction(_:)))
        hamburger.addGestureRecognizer(tap)
        
        let item = UINavigationItem()
        item.leftBarButtonItem = UIBarButtonItem(customView: hamburger)
        (detailContainerViewController?.parentViewController as? UINavigationController)?.navigationBar.items = [item]
        
        detailToHistory()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_once(&once) {
            self.hiddenOrShow(false, animated: false)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MasterSegue" {
            let master = (segue.destinationViewController as? UINavigationController)?.topViewController as? DWTaaskyMasterViewController
            master?.headerStyles = [.History, .Setting]
            master?.urlOfDirectory =
                NSFileManager.defaultManager().URLsForDirectory(
                    NSSearchPathDirectory.DocumentDirectory,
                    inDomains: NSSearchPathDomainMask.UserDomainMask).first
            masterViewController = master
        }
        
        if segue.identifier == "DetailSegue" {
            detailContainerViewController = (segue.destinationViewController as? UINavigationController)?.topViewController
        }
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.pagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - scrollView.bounds.width)
        
        var progress = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
        progress = max(min(1 - progress, 1), 0)
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0/1000
        transform = CATransform3DRotate(transform, CGFloat(M_PI) / 2 * (1 - progress), 0, 1, 0)
        masterViewController?.view.layer.transform = transform
        masterViewController?.view.alpha = progress
        
        ((detailContainerViewController?.parentViewController as? UINavigationController)?.navigationBar.items?.first?.leftBarButtonItem?.customView as? DWHamburgerView)?.imageView.transform =
            CGAffineTransformMakeRotation(CGFloat(M_PI) / 2 * progress)
    }
    
    // MARK: - Action
    func tapHamburgerAction(tap: UITapGestureRecognizer) {
        hiddenOrShow(kHidden, animated: true)
    }
    
    // MARK: - Other
    func hiddenOrShow(show: Bool, animated: Bool) {
        kHidden = !show
        if let masterViewController = masterViewController {
            scrollView.setContentOffset(show ? CGPointZero : CGPoint(x: masterViewController.view.bounds.width, y: 0), animated: animated)
        }
    }
    
    func detailToHistory() {
        guard let flag = (detailViewController as? UIViewController)?.isMemberOfClass(DWHistoryViewController) where flag else {
            detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("historyViewController") as? DWDetailViewController
            (detailContainerViewController?.parentViewController as? UINavigationController)?.navigationBar.topItem?.title = "History"
            return
        }
    }
    
    func detailToSetting() {
        guard let flag = (detailViewController as? UIViewController)?.isMemberOfClass(DWSettingViewController) where flag else {
            detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("settingViewController") as? DWDetailViewController
            (detailContainerViewController?.parentViewController as? UINavigationController)?.navigationBar.topItem?.title = "Setting"
            return
        }
    }
    
    func detailToVedio(url: NSURL?) {
        let viewInfoViewController = DWVedioInfoViewController()
        detailViewController = viewInfoViewController
        (detailContainerViewController?.parentViewController as? UINavigationController)?.navigationBar.topItem?.title = url?.lastPathComponent ?? "UNTITLED"
        viewInfoViewController.url = url
        viewInfoViewController.keynote.play()
    }
}















