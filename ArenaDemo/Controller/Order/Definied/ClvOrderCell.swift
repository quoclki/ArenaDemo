//
//  ClvOrderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/9/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class ClvOrderCell: UICollectionViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceNormal: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    
    private var itemLine: OrderLineItemDTO!
    
    private var quantity: Int = 0 {
        didSet {
            itemLine.quantity = quantity
            lblQuantity.text = quantity.toString()
            btnMinus.isEnabled = quantity > 1

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        btnMinus.touchUpInside(block: btnMinus_Touched)
        btnPlus.touchUpInside(block: btnPlus_Touched)
    }
    
    func updateCell(_ item: OrderLineItemDTO) {
        self.itemLine = item
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.imageURL)
        lblName.text = item.name
        lblPrice.text = item.price
        lblPrice.textColor = .red
        lblPriceNormal.text = item.price
        quantity = item.quantity
        dropShadow(color: UIColor(hexString: "DEDEDE"), offSet: CGSize(5,5), radius: self.cornerRadius)

    }
    
    func btnMinus_Touched(sender: UIButton) {
        quantity -= 1
    }
    
    func btnPlus_Touched(sender: UIButton) {
        quantity += 1
    }
    
}
