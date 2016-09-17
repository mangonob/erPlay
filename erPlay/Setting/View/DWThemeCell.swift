//
//  DWThemeCell.swift
//  erPlay
//
//  Created by Trinity on 16/7/23.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWThemeCell: UITableViewCell {
    // MARK: - Init
    var buttons: [DWBorderButton]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    init() {
        super.init(style: .Default, reuseIdentifier: nil)
        configure()
    }
    
    // MARK: - Other
    func configure() {
        backgroundColor = UIColor.dwBrownishGreyColor()
        buttons = [DWBorderButton(), DWBorderButton(), DWBorderButton()]
        
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Theme", attributes: [
            NSKernAttributeName: 0.82
            ])
        //label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.dwWhiteColor()
        label.sizeToFit()
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 24)
            ])
        
        var prev: DWBorderButton?
        
        buttons?.forEach({ (button) in
            contentView.addSubview(button)
            button.borderColor = UIColor.dwLightishGreenColor()
            
            button.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints([
                NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 36),
                NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 72),
                NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
                ])
            
            if let prev = prev {
                contentView.addConstraints([
                    NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prev, attribute: .Right, multiplier: 1, constant: 15)
                    ])
            }
            
            prev = button
        })
        
        buttons?[0].backgroundColor = UIColor.dwReddishPinkColor()
        contentView.addConstraints([
            NSLayoutConstraint(item: buttons![0], attribute: .Left, relatedBy: .Equal, toItem: label, attribute: .Right, multiplier: 1, constant: 27)
            ])
        buttons?[1].backgroundColor = UIColor.whiteColor()
        buttons?[2].backgroundColor = UIColor.blackColor()
    }
}
























