//
//  DWHistoryLeastCell.swift
//  erPlay
//
//  Created by Trinity on 16/7/23.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWHistoryLeastCell: UITableViewCell {
    lazy var kLabel = UILabel()
    lazy var kCheckBox = DWCheckBox()
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    init() {
        super.init(style: .Default, reuseIdentifier: nil)
        configure()
    }
    
    // MARK: - Action
    func changeCheckedTarget(sender: DWCheckBox) {
        sender.setChecked(!sender.checked, animated: true)
    }
    
    // MARK: - Other
    func configure() {
        backgroundColor = UIColor.dwBrownishGreyColor()
        
        contentView.addSubview(kLabel)
        contentView.addSubview(kCheckBox)
        
        kLabel.translatesAutoresizingMaskIntoConstraints = false
        kCheckBox.translatesAutoresizingMaskIntoConstraints = false
        kCheckBox.addTarget(self, action: #selector(changeCheckedTarget(_:)), forControlEvents: .TouchUpInside)
        kCheckBox.interactionMargin = 10
        
        kLabel.text = "Start from least playback"
        kLabel.numberOfLines = 0
        kLabel.textColor = UIColor.dwWhiteColor()
        
        contentView.addConstraints([
            NSLayoutConstraint(item: kLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kCheckBox, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kCheckBox, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: kLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: kLabel, attribute: .Right, relatedBy: .Equal, toItem: kCheckBox, attribute: .Left, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: kCheckBox, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 26),
            NSLayoutConstraint(item: kCheckBox, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 26),
            ])
    }
    
    // MARK: - <#mark#>
}
