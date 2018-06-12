//
//  TbvPostCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/12/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class TbvPostCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ item: PostDTO) {
        lblName.attributedText = item.title?.rendered?.htmlAttribute
    }
    
}
