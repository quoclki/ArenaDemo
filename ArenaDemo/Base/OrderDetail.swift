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
    
    func orderProduct(dto: ProductDTO) {
        if let item = orderDTO.line_items.first(where: { $0.id == dto.id }) {
            item.quantity = (item.quantity ?? 0) + 1
        }
        
        
        
    }
    
    
    
}
