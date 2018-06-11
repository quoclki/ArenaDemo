//
//  ImageStore.swift
//  iOne2
//
//  Created by Huynh Minh Thien on 4/18/18.
//  Copyright © 2018 Lu Kien Quoc. All rights reserved.
//

import UIKit
import CustomControl

class ImageStore: NSObject {
    
    /// shared instant
    static var shared = ImageStore()
    
    var imgDict: [String: AnyObject?] = [:]
    
    /// set image to ImageView
    func setImg(toImageView imv: UIImageView, imgURL: String?, defaultImg: UIImage? = nil, completedFunc: ((UIImage?) -> Void)? = nil) {
        guard let imgURL = imgURL, imgURL.isImageUrl() else {
            imv.image = defaultImg
            completedFunc?(defaultImg)
            return
        }
        if let item = imgDict.filter({$0.0 == imgURL}).first {
            // if has key in dictionary
            if let img = item.1 as? UIImage {
                // if img has been completely downloaded
                imv.image = img
                completedFunc?(img)
            } else {
                // if img has been downloaded but not finished yet -> download img but not store in imgDict
                imv.image = defaultImg
                Helper.getImageAsync(imgURL, complete: {
                    if var newImage = $0 {
                        if newImage.size.width > 450 {
                            newImage = newImage.resize(newWidth: 450) ?? UIImage()
                        }
                        imv.image = newImage
                        self.imgDict.updateValue(newImage, forKey: imgURL)
                        completedFunc?(newImage)
                    }
                })
            }
            return
        }
        // download new item in background, and add it to dictionary
        imgDict.updateValue(nil, forKey: imgURL)
        imv.image = defaultImg
        
        Helper.getImageAsync(imgURL, complete: {
            if let image = $0?.resize(newWidth: ($0?.size.width ?? 0) > 450 ? 450 : ($0?.size.width ?? 0)) {
                imv.image = image
                self.imgDict.updateValue(image, forKey: imgURL)
                completedFunc?(image)
            }
        })
    }
}
