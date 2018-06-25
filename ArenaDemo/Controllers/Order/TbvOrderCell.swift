//
//  TbvOrderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class TbvOrderCell: UITableViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    
    private var item: OrderLineItemDTO!
    var updateTotal: (() -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ item: OrderLineItemDTO) {
        self.item = item
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.imageURL)
        lblName.text = item.name
        lblQuantity.text = item.quantity.toString()
        lblPrice.text = item.total.toString()
        
        btnMinus.touchUpInside(block: btnMinus_Touched)
        btnPlus.touchUpInside(block: btnPlus_Touched)
        
    }
 
    func btnMinus_Touched(sender: UIButton) {
        if item.quantity <= 1 {
            return
        }
        item.quantity -= 1
        item.calculateSubTotal()
        updateTotal?()
        updateCell(item)
    }
    
    func btnPlus_Touched(sender: UIButton) {
        item.quantity += 1
        item.calculateSubTotal()
        updateTotal?()
        updateCell(item)
    }
    
}
