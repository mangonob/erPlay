//
//  TableViewController.swift
//  SwiftTest
//
//  Created by Trinity on 16/7/21.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWSettingViewController: UITableViewController, DWDetailViewController {
    
    private var _containerViewController: DWTaaskyContainerViewController?
    var containerViewController: DWTaaskyContainerViewController? {
        set {
            _containerViewController = newValue
        }
        get {
            return _containerViewController
        }
    }
    
    // MARK: - Properties
    lazy private var kPreferencer = SettingAccesser()
    
    lazy var gestureSettings: NSDictionary? = {
        let path = NSBundle.mainBundle().pathForResource("gestureSetting", ofType: "plist")!
        return NSDictionary(contentsOfFile: path)
    }()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.dwBrownishGreyColor()
        tableView.separatorStyle = .None
        
        kPreferencer.tryToDefault()
        
    }

    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = RGB(136, 136, 136)
        let label = UILabel()
        
        var str = ""
        switch section {
        case 0: str = "Apperance"
        case 1: str = "History"
        case 2: str = "Gesture"
        default: break
        }
        
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "Helvetica-Bold", size: 14)
        label.textAlignment = .Center
        
        label.attributedText = NSAttributedString(string: str, attributes: [
            NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 14)!,
            NSKernAttributeName: 0.82
            ])
        
        header.addSubview(label)
        
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        header.addConstraints([
            NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: header, attribute: .Left, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: header, attribute: .CenterY, multiplier: 1, constant: 0),
            ])

        return header
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 4
        default :break
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let themeCell = DWThemeCell()
            let dft = kPreferencer[indexPath] as? Int ?? 0
            
            themeCell.buttons?.forEach({ (button) in
                button.setBorderHidden(true, animated: false)
                button.addTarget(self, action: #selector(changeTheme(_:)), forControlEvents: .TouchUpInside)
            })
            
            themeCell.buttons?[dft].setBorderHidden(false, animated: true)
            
            return themeCell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = DWHistoryLimitCell()
                cell.minValue = 5
                cell.maxValue = 200
                cell.currValue = kPreferencer[indexPath] as? Int ?? 42
                cell.kSlider.addTarget(self, action: #selector(historyLimitChanged(_:)), forControlEvents: .ValueChanged)
                return cell
            case 1:
                let cell = DWHistoryLeastCell()
                cell.kCheckBox.setChecked(kPreferencer[indexPath] as? Bool ?? false, animated: false)
                cell.kCheckBox.kHook = indexPath
                cell.kCheckBox.checkColor = UIColor.dwGreenishTealColor()
                cell.kCheckBox.addTarget(self, action: #selector(changeBoolAction(_:)), forControlEvents: .TouchUpInside)
                return cell
            default: break
            }
        case 2:
            let cell = DWGestureCell()
            cell.dwImage = UIImage(named: (gestureSettings?["images"] as! NSArray)[indexPath.row] as! String)
            cell.dwText = (gestureSettings?["texts"] as! NSArray)[indexPath.row] as? String
            cell.kCheckBox.setChecked(kPreferencer[indexPath] as? Bool ?? false, animated: false)
            cell.kCheckBox.checkColor = UIColor.dwGreenishTealColor()
            cell.kCheckBox.kHook = indexPath
            cell.kCheckBox.addTarget(self, action: #selector(changeBoolAction(_:)), forControlEvents: .TouchUpInside)
            return cell
        default: break
        }
        
        return /* can't return this */UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 32
        }
        return 0.1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 60
        case 1: return 46
        case 2: return 46
        default: break
        }
        
        return 0
    }
    
    // MARK: - Actions
    func changeTheme(sender: DWBorderButton){
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? DWThemeCell
        cell?.buttons?.forEach({ (button) in
            button.setBorderHidden(true, animated: true)
        })
        kPreferencer[indexPath] = cell?.buttons?.indexOf(sender) ?? 0
        sender.setBorderHidden(false, animated: true)
    }
    
    func historyLimitChanged(sender: UISlider) {
        let indexPath = NSIndexPath(forRow: 0, inSection: 1)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? DWHistoryLimitCell
        kPreferencer[indexPath] = cell?.currValue
    }
    
    func changeBoolAction(sender: DWCheckBox) {
        if let indexPath = sender.kHook as? NSIndexPath {
            kPreferencer[indexPath] = sender.checked
        }
    }
    // MARK: - Other
}

































