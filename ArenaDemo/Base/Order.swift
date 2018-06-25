//
//  Order.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import Foundation
import ArenaDemoAPI

class Order {
    static var shared = Order()
    
    var orderDTO: OrderDTO = OrderDTO()
    
    var subTotal: Double {
        return orderDTO.line_items.reduce(0, { (value, dto) -> Double in
            return value + (dto.subtotal?.toDouble() ?? 0)
        })
    }
    
    var totalItem: Int {
        return orderDTO.line_items.reduce(0, { (value, dto) -> Int in
            return value + (dto.quantity ?? 0)
        })
    }
    
    func orderProduct(dto: ProductDTO) {
        if let item = orderDTO.line_items.first(where: { $0.product_id == dto.id }) {
            item.quantity = (item.quantity ?? 0) + 1
            item.calculateSubTotal()
            return
        }
        
        let line = OrderLineItemDTO()
        line.product_id = dto.id
        line.quantity = 1
        line.name = dto.name
        line.sku = dto.sku
        line.price = dto.price
        line.imageURL = dto.images.first?.src
        line.calculateSubTotal()
        orderDTO.line_items.append(line)
        
    }
    
    func clearOrder() {
        orderDTO = OrderDTO()
    }
    
}

extension OrderLineItemDTO {
    func calculateSubTotal() {
        self.subtotal = (Double(self.quantity ?? 0) * (self.price?.toDouble() ?? 0)).toString()

    }
}
