//
//  ClvCategoryCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/4/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

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
    }

    func updateCell(_ item: CategoryDTO) {
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.image?.src)
        lblName.text = item.name?.uppercased()
        self.cornerRadius = 5
        dropShadow(color: UIColor(hexString: "DEDEDE"), offSet: CGSize(5,5), radius: self.cornerRadius)
    }
    
}
