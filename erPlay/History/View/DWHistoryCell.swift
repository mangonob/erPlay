//
//  DWHistoryCell.swift
//  erPlay
//
//  Created by Trinity on 16/7/28.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWHistoryCell: UITableViewCell {
    var kURL: NSURL? {
        didSet {
            updateImage()
            updateLabel()
        }
    }
    
    // MARK: - Lazy Properties
    private var _thumbView: DWHistoryThumbView!
    var kThumbView: DWHistoryThumbView {
        get {
            if _thumbView == nil {
                _thumbView = DWHistoryThumbView()
                
                contentView.addSubview(_thumbView)
                
                _thumbView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addConstraints([
                    NSLayoutConstraint(item: _thumbView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50),
                    NSLayoutConstraint(item: _thumbView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50),
                    NSLayoutConstraint(item: _thumbView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: _thumbView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 24),
                    ])
                updateImage()
            }
            return _thumbView
        }
    }
    
    private var _label: UILabel!
    var kLabel: UILabel {
        get {
            if _label == nil {
                _label = UILabel()
                contentView.addSubview(_label)
                _label.text = "UILabel\(unsafeAddressOf(_label))"
                _label.font = UIFont.systemFontOfSize(14)
                _label.textAlignment = .Right
                _label.sizeToFit()
                _label.textColor = UIColor.dwWhiteColor()
                
                _label.translatesAutoresizingMaskIntoConstraints = false
                contentView.addConstraints([
                    NSLayoutConstraint(item: _label, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -24),
                    NSLayoutConstraint(item: _label, attribute: .Left, relatedBy: .GreaterThanOrEqual, toItem: kThumbView, attribute: .Right, multiplier: 1, constant: 15),
                    NSLayoutConstraint(item: _label, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0),
                ])
            }
            return _label
        }
    }
    
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
        contentView.backgroundColor = UIColor.dwBrownishGreyColor()
        backgroundColor = UIColor.dwBrownishGreyColor()
        
        kThumbView
        kLabel
    }
    
    func updateImage() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let thumbnail = self.kURL?.thumbnail(){
                dispatch_async(dispatch_get_main_queue(), {
                    self.kThumbView.image = thumbnail
                })
            }
        }
    }
    
    func updateLabel() {
        kLabel.text = kURL?.lastPathComponent
    }
}























