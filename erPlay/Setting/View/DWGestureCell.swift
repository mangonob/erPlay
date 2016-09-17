//
//  DWGestureCell.swift
//  erPlay
//
//  Created by Trinity on 16/7/23.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWGestureCell: UITableViewCell {
    lazy var kImageView = UIImageView()
    lazy var kLabel = UILabel()
    lazy var kCheckBox = DWCheckBox()
    
    var dwImage: UIImage? {
        didSet {
            kImageView.image = dwImage
        }
    }
    
    var dwText: String? {
        didSet {
            kLabel.attributedText = NSAttributedString(string: dwText!, attributes: [NSKernAttributeName: 0.82])
        }
    }
    
    // MARK: - Init
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
        
        contentView.addSubview(kImageView)
        contentView.addSubview(kLabel)
        contentView.addSubview(kCheckBox)
        
        kImageView.translatesAutoresizingMaskIntoConstraints = false
        kLabel.translatesAutoresizingMaskIntoConstraints = false
        kCheckBox.translatesAutoresizingMaskIntoConstraints = false
        
        kImageView.contentMode = .Center
        
        kLabel.numberOfLines = 1
        kLabel.adjustsFontSizeToFitWidth = true
        kLabel.textColor = UIColor.dwWhiteColor()
        kCheckBox.interactionMargin = 10
        
        contentView.addConstraints([
            NSLayoutConstraint(item: kImageView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kCheckBox, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: kImageView, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kImageView, attribute: .Width, relatedBy: .Equal, toItem: kImageView, attribute: .Height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20),
            
            NSLayoutConstraint(item: kLabel, attribute: .Left, relatedBy: .Equal, toItem: kImageView, attribute: .Right, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: kLabel, attribute: .Right, relatedBy: .Equal, toItem: kCheckBox, attribute: .Left, multiplier: 1, constant: -8),
            
            NSLayoutConstraint(item: kCheckBox, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 26),
            NSLayoutConstraint(item: kCheckBox, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 26),
            NSLayoutConstraint(item: kCheckBox, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -20),
            ])
        kCheckBox.addTarget(self, action: #selector(changeBorderHiddenTarget(_:)), forControlEvents: .TouchUpInside)
    }
    
    func changeBorderHiddenTarget(sender: DWCheckBox) {
        sender.setChecked(!sender.checked, animated: true)
    }
}
