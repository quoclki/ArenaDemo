//
//  TbvAccountOrderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/25/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class TbvAccountOrderCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func updateCell(_ item: OrderDTO) {
        lblDate.text = item.date_created_gmt?.string("dd/MM/yyyy HH:mm:ss")
        lblStatus.text = item.status
        
    }
    
}
