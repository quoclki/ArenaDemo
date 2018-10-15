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

    func checkItemInOrder(_ id: Int?) -> Bool {
        guard let id = id else {
            return false
        }
        
        if !orderDTO.line_items.filter({ $0.product_id == id }).isEmpty {
            return true
        }
        
        return false
    }
    
}

extension OrderDTO {
    var total: Double {
        let totalWithNoDiscount = line_items.reduce(0, { (value, dto) -> Double in
            return value + (dto.total.toDouble() )
        })
        
        let totalDiscount = self.coupon_lines.reduce(0) { (value, dto) -> Double in
            return value + (dto.discount?.toDouble() ?? 0)
        }
        
        return totalWithNoDiscount - totalDiscount
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
    
    func updateCoupon(_ coupon: CouponDTO) -> String? {
        if let dateExpired = coupon.date_expires, dateExpired < Date() {
            return "Hết hạn"
        }

        if !self.coupon_lines.filter({ $0.code == coupon.code }).isEmpty {
            return "Đơn hàng đã tồn tại mã giảm giá này"
        }
        
        guard let minAmt = coupon.minimum_amount?.toDouble(), let maxAmt = coupon.maximum_amount?.toDouble() else {
            return "Cấu hình sai"
        }

        if total < minAmt || total > maxAmt {

        }

        switch coupon.discount_type ?? "" {
        case EDiscountType.fixed_cart.rawValue:

            break

        case EDiscountType.fixed_product.rawValue:


            break


        case EDiscountType.percent.rawValue:


            break


        default:
            break
        }
        
        let couponLine = CouponLineDTO()
        couponLine.code = coupon.code
        couponLine.discount = 0.0.toCurrencyString()
        couponLine.discount_tax = 0.0.toCurrencyString()
        self.coupon_lines.append(couponLine)
        
        return nil
        
    }
    
    
}

extension OrderLineItemDTO {
    func calculateSubTotal() {
        self.total = (Double(self.quantity) * (self.price?.toDouble() ?? 0)).toString()

    }
}
