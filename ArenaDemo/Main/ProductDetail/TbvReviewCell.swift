//
//  TbvReviewCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/11/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class TbvReviewCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(item: ReviewDTO) {
        lblText.text = item.review
    }
    
}
