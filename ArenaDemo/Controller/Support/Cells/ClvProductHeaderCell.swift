//
//  ClvProductHeaderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/14/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit

class ClvProductHeaderCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ name: String) {
        lblName.text = name
    }
    
}
