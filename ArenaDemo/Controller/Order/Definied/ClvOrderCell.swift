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

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceNormal: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ item: OrderLineItemDTO) {
        
    }
    
}
