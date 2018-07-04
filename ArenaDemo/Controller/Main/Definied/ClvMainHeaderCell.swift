//
//  ClvMainHeaderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/3/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit

class ClvMainHeaderCell: UICollectionViewCell {

    @IBOutlet weak var vLeft: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnViewMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ item: MainDataGroup) {
        vLeft.backgroundColor = Base.baseColor
        lblName.textColor = vLeft.backgroundColor
        lblName.text = item.name?.uppercased()
    }
    
}
