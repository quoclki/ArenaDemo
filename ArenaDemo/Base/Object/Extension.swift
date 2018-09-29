//
//  Extension.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 9/29/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import Foundation
import ArenaDemoAPI

extension BaseRequest {
    convenience init(page: Int) {
        self.init()
        self.page = page
        self.per_page = 99
        
    }
}

extension BaseVCtrl {
    func checkResponse<T: BaseResponse>(_ response: T) -> Bool {
        if !response.success && !response.isCancel {
            _ = showWarningAlert(title: "Thông báo", message: response.message?.translate ?? "", buttonTitle: "OK")
        }
        
        return response.success
    }
    
}

extension ProductDTO {
    func getPriceFormat() -> NSAttributedString? {
        if let regularPrice = self.regular_price?.toDouble(), let salePrice = self.sale_price?.toDouble(), regularPrice != 0 {
            let priceString = regularPrice.toCurrencyString()
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: priceString)
            attributeString.addAttributes([NSAttributedStringKey.strikethroughStyle: 1, .foregroundColor: UIColor(hexString: "9B9B9B")], range: NSMakeRange(0, attributeString.length))
            
            let ratio = ((regularPrice - salePrice) / regularPrice).round2Decimal
            attributeString.append(NSAttributedString(string: " \( Int(ratio * 100).toString() )%"))

            return attributeString
        }
        
        return nil

    }
}

extension CALayer {
    func applySketchShadow (
        color: UIColor = UIColor(hexString: "CDCCCD"),
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 8,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
}

extension EOrderStatus {
    var name: String {
        switch self {
        case .any:
            return "Bất kí"
        case .pending:
            return "Tạm dừng"
        case .processing:
            return "Đang xử lý"
        case .onhold:
            return "Đang giữ"
        case .completed:
            return "Hoàn tất"
        case .cancelled:
            return "Đã huỷ"
        case .refunded:
            return "Đã trả lại"
        case .failed:
            return "Lỗi"
        }
    }
    
    var color: UIColor {
        return .yellow
    }
}
