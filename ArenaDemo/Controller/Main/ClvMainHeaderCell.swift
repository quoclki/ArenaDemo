//
//  ClvMainHeaderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/3/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class ClvMainHeaderCell: UICollectionViewCell {

    @IBOutlet weak var vLeft: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnViewMore: UIButton!
    
    private var item: MainDataGroup!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btnViewMore.touchUpInside(block: btnViewMore_Touched)
    }

    func updateCell(_ item: MainDataGroup) {
        self.item = item
        vLeft.backgroundColor = Base.baseColor
        lblName.textColor = vLeft.backgroundColor
        lblName.text = item.category.name?.uppercased()
    
    }
    
    func btnViewMore_Touched(sender: UIButton) {
        guard let parentVCtrl = self.parentViewController else {
            return
        }
    
        let detail = CategoryDetailVCtrl(item.category)
        parentVCtrl.navigationController?.pushViewController(detail, animated: true)

    }
    
}
