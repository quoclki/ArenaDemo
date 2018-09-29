//
//  TbvFavoriteCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 9/29/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class TbvFavoriteCell: UITableViewCell {

    @IBOutlet weak var vBorder: UIView!
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceNormal: UILabel!

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    private var item: ProductDTO!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnDelete.touchUpInside(block: btnDelete_Touched)
        btnAddToCart.touchUpInside(block: btnAddToCart_Touched)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vBorder.layer.applySketchShadow(blur: vBorder.cornerRadius)

    }
    
    func updateCell(_ item: ProductDTO) {
        self.item = item
        ImageStore.shared.setImg(toImageView: imv, imgURL: item.images.first?.src) { (img) in
            let image = img?.resize(newWidth: self.imv.width)
            self.imv.image = image
            self.imv.contentMode = .topLeft
            self.imv.clipsToBounds = true
        }
        lblName.text = item.name
        lblPrice.text = item.sale_price?.toCurrencyString()
        lblPrice.textColor = Base.baseColor
        btnAddToCart.isEnabled = !Order.shared.checkItemInOrder(item.id)
        
        if let attributed = item.normalPriceAttributed {
            lblPriceNormal.attributedText = attributed
            return
        }
        
        let attributed = item.getPriceFormat()
        lblPriceNormal.attributedText = attributed
        item.normalPriceAttributed = attributed

    }
    
    func btnDelete_Touched(sender: UIButton) {
        guard let favorite = parentViewController as? AccountFavoriteVCtrl else {
            return
        }
        
        guard let tableView = self.tableView else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: self) else {
            return
        }
        
        favorite.handleDelete(tableView, indexPath: indexPath)
        
    }
    
    func btnAddToCart_Touched(sender: UIButton) {
        guard let favorite = parentViewController as? AccountFavoriteVCtrl else {
            return
        }

        sender.isEnabled = false
        
        let lineItem = OrderLineItemDTO()
        lineItem.product_id = item.id
        lineItem.name = item.name
        lineItem.price = item.price
        lineItem.productDTO = item
        lineItem.quantity = 1
        Order.shared.orderDTO.updateOrderLineItem(lineItem)
        favorite.updateCart()

    }
    
}
