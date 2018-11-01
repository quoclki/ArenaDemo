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
    var subTotal: Double {
        return line_items.reduce(0, { (value, dto) -> Double in
            return value + dto.subtotal.toDouble()
        })
    }
    
    var total: Double {
        let totalDiscount = self.coupon_lines.reduce(0) { (value, dto) -> Double in
            return value + (dto.discount?.toDouble() ?? 0)
        }
        
        return subTotal + totalDiscount
    }
    
    var totalItem: Int {
        return line_items.reduce(0, { (value, dto) -> Int in
            return value + dto.quantity
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
        updateCoupon()
    }
    
    func deleteOrderLintItem(_ item: OrderLineItemDTO) {
        line_items.remove(item)
        Base.container.updateTotalItem()
        updateCoupon()
    }
    
    func updateCoupon(_ coupon: CouponDTO) -> String? {
        if let dateExpired = coupon.date_expires, dateExpired < Date() {
            return "Mã giảm giá hết hạn"
        }

        if !self.coupon_lines.filter({ $0.code == coupon.code }).isEmpty {
            return "Đơn hàng đã tồn tại mã giảm giá này"
        }
        
        guard let minAmt = coupon.minimum_amount?.toDouble(), let maxAmt = coupon.maximum_amount?.toDouble(), let amount = coupon.amount?.toDouble(), amount > 0 else {
            return "Cấu hình sai mã giảm giá"
        }

        if (total < minAmt || total > maxAmt) && maxAmt > 0 {
            return "Đơn hàng vượt chỉ tiêu tối đa của mã giảm giá"
        }
        
        if coupon.individual_use == true && !self.coupon_lines.isEmpty {
            return "Mã giảm giá hỉ dùng cho cá nhân"
        }
        
        if coupon.exclude_sale_items == true && !self.line_items.filter({ $0.productDTO?.regular_price != $0.productDTO?.sale_price }).isEmpty {
            return "Mã giảm giá không bao gồm sản phẩm đang giảm giá"
        }

        let lstEmail = coupon.email_restrictions
        if !lstEmail.isEmpty && !lstEmail.contains(self.billing?.email ?? "") {
            return "Email không thể sử dụng mã giảm giá này"
        }
        
        let lstItemAllowDiscount = self.line_items.filter({ $0.checkValidInCoupon(coupon) })
        if lstItemAllowDiscount.isEmpty {
            return "Không có sản phẩm nào phù hợp với mã giảm giá này"
        }
        
        let couponLine = CouponLineDTO()
        couponLine.code = coupon.code
        couponLine.discount_tax = "0"
        couponLine.couponDTO = coupon

        switch coupon.discount_type ?? "" {
        case EDiscountType.fixed_cart.rawValue:
            couponLine.discount = "-\( amount )"
            self.coupon_lines.append(couponLine)

        case EDiscountType.fixed_product.rawValue:
            // update coupon
            let totalItem = lstItemAllowDiscount.reduce(0) { (value, dto) -> Int in
                return value + (dto.quantity)
            }

            if totalItem == 0 {
                return "Không tồn tại sản phẩm được giảm giá trong mã giảm giá này"
            }
            
            couponLine.discount = (-Double(totalItem) * amount).toString()
            self.coupon_lines.append(couponLine)
            updateCouponPercent()

        case EDiscountType.percent.rawValue:
            self.coupon_lines.append(couponLine)
            updateCouponPercent()

        default:
            break
        }
        
        return nil
        
    }
    
    func calculateTotalIfNeeded() {
        let lstCoupon = self.coupon_lines
        if lstCoupon.isEmpty {
            return
        }
        
        let lstCouponForProduct = lstCoupon.filter({ $0.couponDTO?.discount_type == EDiscountType.fixed_product.rawValue })
        let lstCouponCartAndPrecent = lstCoupon.filter({ [EDiscountType.percent.rawValue, EDiscountType.fixed_cart.rawValue].contains($0.couponDTO?.discount_type ?? "") })

        // Handle coupon for product
        for coupon in lstCouponForProduct {
            guard let couponDTO = coupon.couponDTO else {
                continue
            }
            
            self.line_items.filter({ $0.checkValidInCoupon(couponDTO) }).forEach { (item) in
                let total = item.total.toDouble()
                let amount = couponDTO.amount?.toDouble() ?? 0
                let totalAfterDiscount = total - Double(item.quantity) * amount
                item.total = totalAfterDiscount.toString()
            }
        }
        
        // Handle coupon for fixed cart vs percent
        let totalDiscountAmtForCartAndPercent = lstCouponCartAndPrecent.reduce(0) { (value, dto) -> Double in
            return value + (dto.discount?.toDouble() ?? 0)
        }
        let totalQuantity = self.line_items.reduce(0) { (value, dto) -> Int in
            return value + dto.quantity
        }
        
        var totalAmtDiscount: Double = 0
        for (index, element) in self.line_items.enumerated() {
            var total = element.total.toDouble()
            if index == self.line_items.count - 1 {
                let totalAmt = totalDiscountAmtForCartAndPercent - totalAmtDiscount
                total += totalAmt
                element.total = total.toString()
                continue
            }
            
            let discount = Double(element.quantity) / Double(totalQuantity) * totalDiscountAmtForCartAndPercent
            total += discount
            totalAmtDiscount += discount
            element.total = total.toString()
            
        }
        
    }
    
    private func updateCouponPercent() {
        let lstCoupon = self.coupon_lines.filter({ [EDiscountType.percent.rawValue, EDiscountType.fixed_product.rawValue].contains($0.couponDTO?.discount_type ?? "")})
        let lstCouponPercent = lstCoupon.filter({ $0.couponDTO?.discount_type == EDiscountType.percent.rawValue }).sorted(by: { ($0.couponDTO?.amount?.toDouble() ?? 0) < ($1.couponDTO?.amount?.toDouble() ?? 0) })
        if !lstCouponPercent.isEmpty {
            let totalWithNoDiscount = self.subTotal
            var totalDiscountPercent: Double = 0
            let totalDiscountProduct = lstCoupon.filter({ $0.couponDTO?.discount_type == EDiscountType.fixed_product.rawValue }).reduce(0) { (value, dto) -> Double in
                return value + (dto.discount?.toDouble() ?? 0)
            }
            
            lstCouponPercent.forEach { (coupon) in
                let value = totalWithNoDiscount + totalDiscountPercent + totalDiscountProduct
                coupon.discount = (-value * (coupon.couponDTO?.amount?.toDouble() ?? 0) / 100).toString()
                totalDiscountPercent += (coupon.discount?.toDouble() ?? 0)
            }
        }
    }
    
    private func updateCoupon() {
        let lstCoupon = self.coupon_lines.compactMap({ CouponDTO.fromJson($0.couponDTO?.toJson() ?? "") })
        if lstCoupon.isEmpty {
            return
        }
        
        self.coupon_lines.removeAll()
        lstCoupon.forEach { (coupon) in
            _ = self.updateCoupon(coupon)
        }
        
    }
    
}

extension OrderLineItemDTO {
    func calculateSubTotal() {
        self.subtotal = (Double(self.quantity) * (self.price?.toDouble() ?? 0)).toString()
        self.total = self.subtotal
    }
    
    func checkValidInCoupon(_ coupon: CouponDTO) -> Bool {
        let lstProductID = coupon.product_ids
        let lstExcludeProductID = coupon.excluded_product_ids
//        let lstCategory = coupon.product_categories
//        let lstExcludeCategory = coupon.excluded_product_categories
        
        let isProductAllowDiscount = lstProductID.isEmpty ? true : lstProductID.contains(product_id ?? -1)
        let isProductExcludeDiscount = lstExcludeProductID.isEmpty ? true : !lstExcludeProductID.contains(product_id ?? -1)
        return isProductAllowDiscount && isProductExcludeDiscount
    }
}
