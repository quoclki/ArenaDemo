//
//  TbvAccountCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/19/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class TbvAccountCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ item: CustomerDTO) {
        lblName.text = "\( item.first_name ?? "" ) \( item.last_name ?? "" )"
        lblRole.text = item.role?.uppercased()
    }
    
}
