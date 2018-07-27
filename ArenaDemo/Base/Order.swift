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
    
    func updateCusDTO(_ cusDTO: CustomerDTO, isSaveUserDefault: Bool = false) {
        self.cusDTO = cusDTO

        if isSaveUserDefault || UserDefaults.standard.value(forKey: EUserDefaultKey.customerInfo.rawValue) != nil {
            UserDefaults.standard.set(cusDTO.toJson(), forKey: EUserDefaultKey.customerInfo.rawValue)
        }

    }
    
    func clearOrder() {
        orderDTO = OrderDTO()
        Base.container.updateTotalItem()

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
    
    func setupCustomer(_ cusDTO: CustomerDTO) {
        customer_id = cusDTO.id
        shipping = cusDTO.shipping
        billing = cusDTO.billing
    }

    func updateOrderLineItem(_ item: OrderLineItemDTO) {
        item.calculateSubTotal()
        
        if let index = line_items.index(where: { $0.product_id == item.product_id }) {
            line_items[index] = item
        } else {
            line_items.append(item)
        }
        
        Base.container.updateTotalItem()
        
    }
    
    func deleteOrderLintItem(_ item: OrderLineItemDTO) {
        line_items.remove(item)
        Base.container.updateTotalItem()
        
    }
    
}

extension OrderLineItemDTO {
    func calculateSubTotal() {
        self.total = (Double(self.quantity) * (self.price?.toDouble() ?? 0)).toString()

    }
}
