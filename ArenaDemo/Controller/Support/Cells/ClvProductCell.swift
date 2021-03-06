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
    
    private var item: ProductDTO!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateCell(_ item: ProductDTO) {
        self.item = item
        
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.images.first?.src) { (img) in
            let image = img?.resize(newWidth: self.width)
            self.imv.image = image
            self.imv.contentMode = .topLeft
            self.imv.clipsToBounds = true
        }
        lblName.text = item.name
        lblPrice.text = item.sale_price?.toCurrencyString()
        lblPrice.textColor = Base.baseColor

        if let attributed = item.normalPriceAttributed {
            lblNormalPrice.attributedText = attributed
            return
        }
        
        let attributed = item.getPriceFormat()
        lblNormalPrice.attributedText = attributed
        item.normalPriceAttributed = attributed
        

    }

}
