//
//  TbvFavoriteCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 9/29/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class TbvFavoriteCell: UITableViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceNormal: UILabel!

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ item: ProductDTO) {
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
            lblPriceNormal.attributedText = attributed
            return
        }
        
        let attributed = item.getPriceFormat()
        lblPriceNormal.attributedText = attributed
        item.normalPriceAttributed = attributed

    }
    
}
