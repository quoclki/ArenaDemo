//
//  TbvPaymentOrderInfoCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/25/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class TbvPaymentOrderInfoCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ item: OrderLineItemDTO) {
        lblName.text = "\( item.name ?? "" ) x \( item.quantity.toString() )"
        lblValue.text = item.subtotal
    }
    
    func updateCellHeader(name: String, value: String) {
        lblName.text = name.uppercased()
        lblValue.text = name.uppercased()
        
    }
    
}
