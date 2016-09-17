//
//  DWTaaskyMasterViewController.swift
//  Demo
//
//  Created by Trinity on 16/7/15.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWTaaskyMasterViewController: UITableViewController, UINavigationControllerDelegate {
    var containerViewController: DWTaaskyContainerViewController?
    internal var urlsAtDirectory: [NSURL?]?
    internal var headerStyles: [DWTaaskyMasterCellStyle]?
    var lastSelectedRow = 0
    
    var sizeOfHeader: Int {
        get {
            return headerStyles == nil ? 0 : headerStyles!.count
        }
    }
    
    var urlOfDirectory: NSURL? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.rasterizationScale = UIScreen.mainScreen().scale
        view.layer.shouldRasterize = true
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = ""
    }
    
    // MARK: - NavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let to = viewController as? DWTaaskyMasterViewController {
            to.containerViewController = containerViewController
            containerViewController?.masterViewController = to
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DWMasterTransition()
    }
    
    // MARK: - TableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getUrlsAtDirectory()
        if let a = urlsAtDirectory {
            return a.count + sizeOfHeader
        }
        return sizeOfHeader
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = DWTaaskyMasterCell()
        
        let row = indexPath.row
        if row < sizeOfHeader {
            cell.style = headerStyles![row]
        } else {
            cell.configure(urlsAtDirectory?[row - sizeOfHeader])
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - TableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastSelectedRow = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? DWTaaskyMasterCell
        
        if let cell = cell {
            switch cell.style {
            case .Directory:
                let newdw = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("masterViewController") as? DWTaaskyMasterViewController
                newdw?.urlOfDirectory = urlsAtDirectory?[indexPath.row - sizeOfHeader]
                if let newdw = newdw {
                    newdw.headerStyles = [DWTaaskyMasterCellStyle.Return]
                    navigationController?.pushViewController(newdw, animated: true)
                }
            case .Return:
                navigationController?.popViewControllerAnimated(true)
            case .Setting:
                toSetting()
            case .History:
                toHistory()
            case .File:
                toVedio(urlsAtDirectory?[indexPath.row - sizeOfHeader])
            default: break
            }
        }
    }

    // MARK: - Other
    func getUrlsAtDirectory() {
        do {
            let enumerator = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(urlOfDirectory!.path!)
            
            urlsAtDirectory = enumerator.filter({ (filename) -> Bool in
                return filename[filename.startIndex] != "."
            }).map({ (filename) -> NSURL? in
                return urlOfDirectory?.URLByAppendingPathComponent(filename)
            })
        } catch {
            urlsAtDirectory = nil
        }
    }
    
    func toSetting() {
        containerViewController?.detailToSetting()
    }
    
    func toHistory() {
        containerViewController?.detailToHistory()
    }
    
    func toVedio(url: NSURL?) {
        containerViewController?.detailToVedio(url)
    }
}





























