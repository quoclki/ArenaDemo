//
//  ClvProductCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/7/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class ClvProductCell: UICollectionViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(item: ProductDTO) {
        lblName.text = item.name
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.images.first?.src)
        btnInfo.touchUpInside(block: btnInfo_Touched)
    }
    
    func btnInfo_Touched(sender: UIButton) {
        guard let clv = self.superview as? UICollectionView else { return }
        guard let vctrl = clv.parentViewController as? MainVCtrl else { return }
        guard let indexPath = clv.indexPath(for: self) else { return }
        vctrl.productViewInfo(indexPath: indexPath)
        
    }
    
}
