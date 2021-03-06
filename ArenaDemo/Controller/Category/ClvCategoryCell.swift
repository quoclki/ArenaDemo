//
//  ClvCategoryCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/4/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class ClvCategoryCell: UICollectionViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imv.cornerRadius = imv.width / 2
        self.layer.applySketchShadow(blur: self.cornerRadius)

    }

    func updateCell(_ item: CategoryDTO) {
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.image?.src)
        imv.contentMode = .scaleAspectFit
        lblName.text = item.name?.uppercased()
        self.cornerRadius = 10
    }
    
}
