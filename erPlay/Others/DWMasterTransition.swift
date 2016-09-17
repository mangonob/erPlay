//
//  DWMasterTransition.swift
//  erPlay
//
//  Created by Trinity on 16/7/17.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWMasterTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var tContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        tContext = transitionContext
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! DWTaaskyMasterViewController
        let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DWTaaskyMasterViewController
        
        let container = transitionContext.containerView()
        
        container?.addSubview(to.tableView)
        container?.insertSubview(from.tableView, belowSubview: to.tableView)
        
        if let nav = from.navigationController, container = container {
            from.view.translatesAutoresizingMaskIntoConstraints = false
            nav.view.addConstraints([
                NSLayoutConstraint(item: from.view, attribute: .Top, relatedBy: .Equal, toItem: nav.navigationBar, attribute: .Bottom, multiplier: 1, constant: 0),
                ])
            container.addConstraints([
                NSLayoutConstraint(item: from.view, attribute: .Width, relatedBy: .Equal, toItem: container, attribute: .Width, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: from.view, attribute: .CenterX, relatedBy: .Equal, toItem: container, attribute: .CenterX, multiplier: 1, constant: 40),
                NSLayoutConstraint(item: from.view, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1, constant: 0),
                ])
            
            to.view.translatesAutoresizingMaskIntoConstraints = false
            nav.view.addConstraints([
                NSLayoutConstraint(item: to.view, attribute: .Top, relatedBy: .Equal, toItem: nav.navigationBar, attribute: .Bottom, multiplier: 1, constant: 0),
                ])
            container.addConstraints([
                NSLayoutConstraint(item: to.view, attribute: .Width, relatedBy: .Equal, toItem: container, attribute: .Width, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: to.view, attribute: .CenterX, relatedBy: .Equal, toItem: container, attribute: .CenterX, multiplier: 1, constant: 40),
                NSLayoutConstraint(item: to.view, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1, constant: 0),
                ])
        }
        
        let cell = from.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: from.lastSelectedRow, inSection: 0))!
        cell.superview?.bringSubviewToFront(cell)
        
        to.tableView.visibleCells.forEach { (c) in
            let ani = CABasicAnimation(keyPath: "position")
            ani.duration = transitionDuration(transitionContext)
            ani.fromValue = NSValue(CGPoint: cell.layer.position)
            ani.delegate = self
            
            let ani2 = CABasicAnimation(keyPath: "opacity")
            ani2.fromValue = 0.0
            ani2.duration = transitionDuration(transitionContext)
            ani2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            ani2.delegate = self
            
            let ani3 = CABasicAnimation(keyPath: "transform")
            ani3.duration = transitionDuration(transitionContext)
            var t = CATransform3DIdentity
            t = CATransform3DRotate(t, CGFloat(M_PI) / 2 * (CGFloat(arc4random()) / CGFloat(UINT32_MAX) * 2 - 1) , 0, 0, 1)
            ani3.fromValue = NSValue(CATransform3D: t)
            ani3.delegate = self
            
            c.layer.addAnimation(ani, forKey: nil)
            c.layer.addAnimation(ani2, forKey: nil)
            c.layer.addAnimation(ani3, forKey: nil)
        }
        
    }
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if tContext != nil {
            tContext?.completeTransition(!tContext!.transitionWasCancelled())
            tContext = nil
        }
    }
}
