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
    
    func updateOrderLineItem(_ item: OrderLineItemDTO) {
        item.calculateSubTotal()

        if let index = orderDTO.line_items.index(where: { $0.product_id == item.product_id }) {
            orderDTO.line_items[index] = item
            return
        }

        orderDTO.line_items.append(item)
        
    }
    
    func setUpCustomer() {
        orderDTO.customer_id = cusDTO.id
        orderDTO.shipping = cusDTO.shipping
        orderDTO.billing = cusDTO.billing

    }
    
    func updateCusDTO(_ cusDTO: CustomerDTO, isSaveUserDefault: Bool = false) {
        self.cusDTO = cusDTO

        if isSaveUserDefault || UserDefaults.standard.value(forKey: EUserDefaultKey.customerInfo.rawValue) != nil {
            UserDefaults.standard.set(cusDTO.toJson(), forKey: EUserDefaultKey.customerInfo.rawValue)
        }

    }
    
    func clearOrder() {
        orderDTO = OrderDTO()
    }
    
}

extension OrderDTO {
    var total: Double {
        return line_items.reduce(0, { (value, dto) -> Double in
            return value + (dto.total.toDouble() )
        })
    }
    
    var totalItem: Int {
        return line_items.reduce(0, { (value, dto) -> Int in
            return value + (dto.quantity )
        })
    }

}

extension OrderLineItemDTO {
    func calculateSubTotal() {
        self.total = (Double(self.quantity) * (self.price?.toDouble() ?? 0)).toString()

    }
}
