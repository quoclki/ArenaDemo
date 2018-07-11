//
//  Order.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import Foundation
import ArenaDemoAPI

class Order {
    static var shared = Order()
    
    var orderDTO: OrderDTO = OrderDTO()
    var cusDTO: CustomerDTO = CustomerDTO()
    var total: Double {
        return orderDTO.line_items.reduce(0, { (value, dto) -> Double in
            return value + (dto.total.toDouble() )
        })
    }
    
    var totalItem: Int {
        return orderDTO.line_items.reduce(0, { (value, dto) -> Int in
            return value + (dto.quantity )
        })
    }
    
    func orderProduct(_ dto: ProductDTO) {
        if let item = orderDTO.line_items.first(where: { $0.product_id == dto.id }) {
            item.quantity = (item.quantity ) + 1
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
    
    func setUpCustomer() {
        orderDTO.customer_id = cusDTO.id
        orderDTO.shipping = cusDTO.shipping
        orderDTO.billing = cusDTO.billing

    }
    
    func clearOrder() {
        orderDTO = OrderDTO()
    }
    
}

extension OrderLineItemDTO {
    func calculateSubTotal() {
        self.total = (Double(self.quantity) * (self.price?.toDouble() ?? 0)).toString()

    }
}
