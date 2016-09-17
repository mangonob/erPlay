//
//  DWHistoryViewController.swift
//  erPlay
//
//  Created by Trinity on 16/7/27.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWHistoryViewController: UITableViewController, DWDetailViewController {
    private lazy var history = HistoryAccesser()
    
    private var _containerViewController: DWTaaskyContainerViewController?
    var containerViewController: DWTaaskyContainerViewController? {
        set {
            _containerViewController = newValue
        }
        get {
            return _containerViewController
        }
    }
    
    private var empty: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.dwWarmGreyColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let url = history.items?[indexPath.row].url {
            let vedioVc = DWERVedioController()
            vedioVc.modalTransitionStyle = .CrossDissolve
            vedioVc.setDone({ [weak vedioVc, weak self] in
                vedioVc?.dismissViewControllerAnimated(true, completion: nil)
                self?.tableView.reloadData()
            })
            containerViewController?.presentViewController(vedioVc, animated: true, completion: nil)
            vedioVc.url = url
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        empty = false
        guard let count = history.items?.count where count != 0 else {
            empty = true
            return 1
        }
        return count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if empty {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.backgroundColor = UIColor.dwWarmGreyColor()
            cell.selectionStyle = .None
            
            let label = UILabel()
            label.text = "No Recently!"
            label.font = UIFont.systemFontOfSize(22)
            label.textColor = UIColor.dwGreyishColor()
            cell.contentView.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraints([
                NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: cell.contentView, attribute: .CenterX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: cell.contentView, attribute: .CenterY, multiplier: 1, constant: 0),
                ])
            
            return cell
        }
        
        let cell = DWHistoryCell()
        cell.selectionStyle = .Blue
        let tap = DWTapGestureRecognizer(target: self, action: #selector(tapOnThumbnail(_:)))
        tap.kHook = indexPath
        cell.kThumbView.addGestureRecognizer(tap)
        
        if let url = history.items?[indexPath.row].url {
            cell.kThumbView.progress = Float(history.getProgress(url))
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let img = url.thumbnail()
                dispatch_async(dispatch_get_main_queue(), { [weak cell] in
                    guard let img = img else { return }
                    cell?.kThumbView.image = img
                })
            })
        }
        
        if let date = history.items?[indexPath.row].date, url = history.items?[indexPath.row].url {
            cell.kLabel.text = descriptionWithDate(date, url: url)
        }
        
        cell.kThumbView.setBorderHidden(false, animated: false)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    // MARK: - Tap ON Thumbnail
    func tapOnThumbnail(tap: DWTapGestureRecognizer) {
        tap.view?.removeGestureRecognizer(tap)
        if let indexPath = tap.kHook as? NSIndexPath {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? DWHistoryCell
            cell?.kThumbView.setBorderHidden(true, animated: true)
            if let url = history.items?[indexPath.row].url {
                history.addProgress(url, progress: 0)
                if let date = history.items?[indexPath.row].date {
                    cell?.kLabel.text = descriptionWithDate(date, url: url)
                }
            }
        }
    }
    
    // MARK: - Other
    func descriptionWithDate(date: NSDate?, url: NSURL?) -> String? {
        guard let date = date, url = url else {
            return nil
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        return String(format: "%@(@ %@)", url.lastPathComponent ?? "", dateFormatter.stringFromDate(date))
    }
}































