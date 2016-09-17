//
//  DWHamburgerView.swift
//  Demo
//
//  Created by Trinity on 16/7/15.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit

class DWHamburgerView: UIView {
    var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // MARK: - Other
    func configure() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "Hamburger")
        imageView.contentMode = UIViewContentMode.Center
        imageView.center = center
        addSubview(imageView)
    }
}
