//
//  TbvOrderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/16/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class TbvOrderCell: UITableViewCell {

    @IBOutlet weak var vBorder: UIView!
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceNormal: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var vActionQuantity: UIView!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblPaymentQuantity: UILabel!
    
    private var itemLine: OrderLineItemDTO!
    private var isPayment: Bool = false
    
    private var quantity: Int = 0 {
        didSet {
            itemLine.quantity = quantity
            itemLine.calculateSubTotal()
            lblQuantity.text = quantity.toString()
            lblPaymentQuantity.text = "Số lượng: \( quantity.toString() )"
            btnMinus.isEnabled = quantity > 1
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnMinus.touchUpInside(block: btnMinus_Touched)
        btnPlus.touchUpInside(block: btnPlus_Touched)
        btnFavourite.touchUpInside(block: btnFavourite_Touched)
        btnDelete.touchUpInside(block: btnDelete_Touched)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vBorder.layer.applySketchShadow(blur: vBorder.cornerRadius)

    }
    
    func updateCell(_ item: OrderLineItemDTO, isPayment: Bool = false) {
        self.itemLine = item
        self.isPayment = isPayment
        vActionQuantity.isHidden = isPayment
        btnFavourite.isHidden = vActionQuantity.isHidden
        lblPaymentQuantity.isHidden = !vActionQuantity.isHidden
        btnDelete.originX = isPayment ? btnFavourite.originX : btnDelete.originX
        
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.productDTO?.images.first?.src)
        lblName.text = item.name
        lblPrice.text = item.price?.toCurrencyString()
        lblPrice.textColor = .red
        lblPriceNormal.text = item.price?.toCurrencyString()
        quantity = item.quantity
        
        item.cellHeight = vBorder.frame.maxY
        
    }
    
    func btnFavourite_Touched(sender: UIButton) {
        
    }
    
    func btnDelete_Touched(sender: UIButton) {
        guard let tableView = self.tableView else {
            return
        }

        guard let indexPath = tableView.indexPath(for: self) else {
            return
        }

        if let parentVCtrl = self.parentViewController as? OrderVCtrl {
            parentVCtrl.handleDelete(tableView, indexPath: indexPath)
            return
        }

        if let parentVCtrl = self.parentViewController as? PaymentVCtrl {
            parentVCtrl.handleDelete(tableView, indexPath: indexPath)
            return
        }
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
        guard let tableView = self.tableView else {
            return
        }
        
        guard let paymentCell = tableView.visibleCells.first(where: { $0 is TbvOrderPaymentCell }) as? TbvOrderPaymentCell else {
            return
        }
        
        paymentCell.updateCell()
        
    }

}
