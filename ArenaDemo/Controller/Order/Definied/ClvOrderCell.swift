//
//  ClvOrderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/9/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class ClvOrderCell: UICollectionViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceNormal: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    
    private var itemLine: OrderLineItemDTO!
    
    private var quantity: Int = 0 {
        didSet {
            itemLine.quantity = quantity
            itemLine.calculateSubTotal()
            lblQuantity.text = quantity.toString()
            btnMinus.isEnabled = quantity > 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        btnMinus.touchUpInside(block: btnMinus_Touched)
        btnPlus.touchUpInside(block: btnPlus_Touched)
        btnFavourite.touchUpInside(block: btnFavourite_Touched)
        btnDelete.touchUpInside(block: btnDelete_Touched)
    }
    
    func updateCell(_ item: OrderLineItemDTO) {
        self.itemLine = item
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.productDTO?.images.first?.src)
        lblName.text = item.name
        lblPrice.text = item.price?.toCurrencyString()
        lblPrice.textColor = .red
        lblPriceNormal.text = item.price?.toCurrencyString()
        quantity = item.quantity
        dropShadow(color: UIColor(hexString: "DEDEDE"), offSet: CGSize(5,5), radius: self.cornerRadius)

    }
    
    func btnFavourite_Touched(sender: UIButton) {
        
    }
    
    func btnDelete_Touched(sender: UIButton) {
        guard let clv = self.superview as? UICollectionView else {
            return
        }
        
        guard let indexPath = clv.indexPath(for: self) else {
            return
        }
        
        guard let parentVCtrl = self.parentViewController as? OrderVCtrl else {
            return
        }
        
        parentVCtrl.handleDelete(clv, indexPath: indexPath)
    }
    
    func btnMinus_Touched(sender: UIButton) {
        quantity -= 1
        updatePaymentCell()
    }
    
    func btnPlus_Touched(sender: UIButton) {
        quantity += 1
        updatePaymentCell()
    }
    
    func updatePaymentCell() {
        guard let clv = self.superview as? UICollectionView else {
            return
        }
        
        guard let paymentCell = clv.visibleCells.first(where: { $0 is ClvOrderPaymentCell }) as? ClvOrderPaymentCell else {
            return
        }
        
        paymentCell.updateCell()
        
    }
    
}
