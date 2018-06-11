//
//  ClvProductCell.swift
//  App199k
//
//  Created by Lu Kien Quoc on 6/7/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class ClvProductCell: UICollectionViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(item: ProductDTO) {
        lblName.text = item.name
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.images.first?.src)
        
    }
    
}
