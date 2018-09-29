//
//  TbvMyOrderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/23/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class TbvMyOrderCell: UITableViewCell {

    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImageForImageView(_ product: ProductDTO) {
        ImageStore.shared.setImg(toImageView: UIImageView(), imgURL: product.images.first?.src) { img in
            let image = img?.resize(newWidth: self.imv.width)
            self.imv.image = image
            self.imv.contentMode = .topLeft
            self.imv.clipsToBounds = true
        }
    }
    
    func updateCell(_ item: OrderLineItemDTO) {
        lblName.text = item.name
        lblDate.text = ""
        
        if let productDTO = item.productDTO {
            setImageForImageView(productDTO)
            return
        }

        if item.isLoading {
            return
        }
        
        let request = GetProductRequest(page: 1)
        request.per_page = 1
        request.id = item.product_id
        
        _ = SEProduct.getListProduct(request, animation: {
            item.isLoading = $0
            
        }, completed: { (response) in
            guard let dto = response.lstProduct.first else {
                return
            }
            
            item.productDTO = dto
            self.setImageForImageView(dto)
            
        })
        
        
    }
    
}
