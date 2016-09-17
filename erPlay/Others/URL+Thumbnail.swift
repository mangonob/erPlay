//
//  URL+Thumbnail.swift
//  erPlay
//
//  Created by Trinity on 16/7/29.
//  Copyright © 2016年 Trinity. All rights reserved.
//

import UIKit
import AVFoundation

extension NSURL {
    func thumbnail() -> UIImage? {
        let asset = AVURLAsset(URL: self)
        let imageAsset = AVAssetImageGenerator(asset: asset)
        let duration = asset.duration
        
        guard let thumbnail = try? imageAsset.copyCGImageAtTime(CMTime(value: duration.value / 2, timescale: duration.timescale), actualTime: nil) else {
            return nil
        }
        
        return UIImage(CGImage: thumbnail)
    }
    
    func randThumbnail() -> UIImage? {
        let asset = AVURLAsset(URL: self)
        let imageAsset = AVAssetImageGenerator(asset: asset)
        let duration = asset.duration
        
        let rflt = max(min(Float(arc4random()) / Float(UInt32.max), 1), 0)
        
        guard let thumbnail = try? imageAsset.copyCGImageAtTime(CMTime(value: CMTimeValue(Float(duration.value) * rflt), timescale: duration.timescale), actualTime: nil) else {
            return nil
        }
        
        return UIImage(CGImage: thumbnail)
    }
    
    func relativeAboutDocuments() -> String {
        guard let path = self.path, range = self.path?.rangeOfString("/Documents/") else {
            return ""
        }
        return path.substringFromIndex(range.endIndex)
    }
}