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
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.images.first?.src) { (img) in
            let image = img?.resize(newWidth: self.width)
            self.imv.image = image
            self.imv.contentMode = .topLeft
            self.imv.clipsToBounds = true
        }
        self.item = item
        
        lblName.text = item.name
        
        if let regularPrice = item.regular_price?.toDouble(), let salePrice = item.sale_price?.toDouble(), regularPrice != 0 {
            lblPrice.text = salePrice.toCurrencyString()
            lblPrice.textColor = Base.baseColor

            let priceString = regularPrice.toCurrencyString()
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceString)
            attributeString.addAttributes([NSAttributedStringKey.strikethroughStyle: 1, .foregroundColor: UIColor(hexString: "9B9B9B")], range: NSMakeRange(0, attributeString.length))
            
            let ratio = ((regularPrice - salePrice) / regularPrice).round2Decimal
            attributeString.append(NSAttributedString(string: " \( Int(ratio * 100).toString() )%"))
            lblNormalPrice.attributedText = attributeString
            
        }

    }

}
