//
//  ClvMainCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/3/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class ClvProductCell: UICollectionViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblNormalPrice: UILabel!
    @IBOutlet weak var vStar: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ item: ProductDTO) {
        lblName.text = item.name
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.images.first?.src)
        imv.contentMode = .scaleAspectFit
        lblPrice.text = item.price?.toCurrencyString()
        lblPrice.textColor = Base.baseColor
        lblNormalPrice.text = item.price?.toCurrencyString()
        
    }

}
