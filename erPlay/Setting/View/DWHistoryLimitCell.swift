//
//  DWHistoryLimitCell.swift
//  erPlay
//
//  Created by Trinity on 16/7/23.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWHistoryLimitCell: UITableViewCell {
    var minValue: Int? {
        didSet {
            updateLabel()
        }
    }
    var maxValue: Int? {
        didSet {
            updateLabel()
        }
    }
    
    var currValue: Int {
        get {
            let maxV = maxValue ?? 100
            let minV = minValue ?? 0
            return Int(Float(maxV - minV) * kSlider.value + Float(minV))
        }
        set {
            let maxV = maxValue ?? 100
            let minV = minValue ?? 0
            kSlider.value = Float(newValue - minV) / Float(maxV - minV)
            updateLabel()
        }
    }
    
    private lazy var kLeftLabel = UILabel()
    private lazy var kRightLabel = UILabel()
    lazy var kSlider = UISlider()
    
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
        
        contentView.addSubview(kLeftLabel)
        contentView.addSubview(kRightLabel)
        contentView.addSubview(kSlider)
        
        kLeftLabel.font = UIFont.systemFontOfSize(14)
        kLeftLabel.textColor = UIColor.dwWhiteColor()
        kRightLabel.font = UIFont.systemFontOfSize(14)
        kRightLabel.textColor = UIColor.dwWhiteColor()
        
        kSlider.tintColor = UIColor.dwGreenishTealColor()
        kSlider.addTarget(self, action: #selector(changeCurrValueTarget(_:)), forControlEvents: .ValueChanged)
        
        kLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        kRightLabel.translatesAutoresizingMaskIntoConstraints = false
        kSlider.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints([
            NSLayoutConstraint(item: kLeftLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kRightLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kSlider, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: kLeftLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: kRightLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: kSlider, attribute: .Left, relatedBy: .Equal, toItem: kLeftLabel, attribute: .Right, multiplier: 1, constant: 13),
            NSLayoutConstraint(item: kSlider, attribute: .Right, relatedBy: .Equal, toItem: kRightLabel, attribute: .Left, multiplier: 1, constant: -13),
            ])
        
        updateLabel()
    }
    
    func updateLabel() {
        kLeftLabel.text = "\((minValue ?? 0) as Int)"
        kRightLabel.text = "\(currValue)/\((maxValue ?? 0) as Int)"
    }
    
    // MARK: - Action
    
    func changeCurrValueTarget(slider: UISlider) {
        updateLabel()
    }
}

















