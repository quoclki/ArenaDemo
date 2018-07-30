//
//  ClvPhotoCell.swift
//  App Ban Hang
//
//  Created by Lu Kien Quoc on 7/30/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class ClvPhotoCell: UICollectionViewCell {

    @IBOutlet weak var imv: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ item: Images) {
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.src)
        imv.contentMode = .scaleAspectFit
    }
    
}
