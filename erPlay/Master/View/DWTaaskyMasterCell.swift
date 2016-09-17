//
//  DWTaaskyMasterCell.swift
//  Demo
//
//  Created by Trinity on 16/7/15.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit
import AVFoundation

public enum DWTaaskyMasterCellStyle : Int {
    case Directory, File, Setting, History, Return, None
}

class DWTaaskyMasterCell: UITableViewCell {
    lazy var kImageView: UIImageView = UIImageView()
    
    var kLabel: DWScrollLabel?
    
    var style: DWTaaskyMasterCellStyle = .None {
        didSet{
            switch style {
            case .Setting:
                kImageView.contentMode = .Center
                kImageView.image = settingImage
                backgroundColor = UIColor(colorDictionary: colorMap!["setting"] as! NSDictionary)
            case .History:
                kImageView.contentMode = .Center
                kImageView.image = historyImage
                backgroundColor = UIColor(colorDictionary: colorMap!["history"] as! NSDictionary)
            case .Return:
                kImageView.contentMode = .Center
                kImageView.image = returnImage
                backgroundColor = UIColor(colorDictionary: colorMap!["return"] as! NSDictionary)
            default: break
            }
        }
    }
    
    //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    init() {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        configure()
    }
    
    private lazy var floderImage = UIImage(named: "floder")
    private lazy var settingImage = UIImage(named: "setting")
    private lazy var returnImage = UIImage(named: "return")
    private lazy var warningImage = UIImage(named: "warning")
    private lazy var historyImage = UIImage(named: "history")
    private lazy var colorMap: NSDictionary! = {
        let path = NSBundle.mainBundle().pathForResource("ColorsMap", ofType: "plist")!
        return NSDictionary(contentsOfFile: path)
    }()
    
    // MARK: - Other
    private func configure() {
        contentView.addSubview(kImageView)
        
        kImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            NSLayoutConstraint(item: kImageView, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kImageView, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kImageView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kImageView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            ])
    }
    
    func configure(url: NSURL?) {
        if let url = url {
            var isDirectory: ObjCBool = false
            NSFileManager.defaultManager().fileExistsAtPath(url.path!, isDirectory: &isDirectory)
            
            if isDirectory.boolValue {
                style = .Directory
                kImageView.contentMode = .Center
                kImageView.image = floderImage
                
//                Old color map
//                backgroundColor = UIColor(colorDictionary: colorMap!["floder"] as! NSDictionary)
                
                let colors = [
                    UIColor.dwTangerineColor(),
                    UIColor.dwOrangeyRedColor(),
                    UIColor.dwBrightBlueColor(),
                    UIColor.dwSunflowerYellowColor(),
                    UIColor.dwReddishPinkColor(),
                    UIColor.dwLightishGreenTwoColor(),
                    UIColor.dwSkyBlueColor(),
                ]
                backgroundColor = colors[(url.lastPathComponent?.hashValue ?? 0) % colors.count]
                
                kLabel = DWScrollLabel()
                kLabel?.text = url.lastPathComponent
                kLabel?.textLabel.font = UIFont.systemFontOfSize(12)
                
                if let label = kLabel {
                    contentView.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    contentView.addConstraints([
                        NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: label, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20),
                        ])
                }
                
                kImageView.translatesAutoresizingMaskIntoConstraints = false
                contentView.constraints.filter({ [weak self] (cst) -> Bool in
                    guard let _self = self else { return false }
                    return cst.firstItem === _self.kImageView && cst.firstAttribute == .CenterY
                }).first?.constant = -8
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    if let thumbnail = url.thumbnail() {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.style = .File
                            self.kImageView.contentMode = .ScaleAspectFill
                            self.kImageView.image = thumbnail
                        })
                    } else {
                            self.style = .None
                            self.kImageView.contentMode = .Center
                            self.kImageView.image = self.warningImage
                            self.backgroundColor = UIColor(colorDictionary: self.colorMap!["warning"] as! NSDictionary)
                    }
                })
            }
        }
    }
}



