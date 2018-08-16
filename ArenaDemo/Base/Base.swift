//
//  Base.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/4/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import Foundation
import ArenaDemoAPI

class Base {
    static var container: ContainerVCtrl!
    static var lstPayment: [PaymentMethodDTO] = []
    
    // Color
    static var baseColor: UIColor = UIColor(hexString: "D0021B")
    static var titleTintColor = UIColor.white
    static var logo: UIImage {
        return UIImage(named: "img-Logo", in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
    }
    
    static func getAccessoryKeyboard(_ action: @escaping (() -> ())) -> UIView {
        let vAccessory = UIView()
        vAccessory.backgroundColor = UIColor(hexString: "F1F2F2")
        vAccessory.frame = CGRect(0, 0, Ratio.width, 40)
        
        let btnDone = UIButton(type: .system)
        btnDone.touchUpInside { (sender) in
            action()
        }
        btnDone.setTitle("Xong", for: .normal)
        btnDone.frame = CGRect(Ratio.width - 75, 0, 60, vAccessory.height)
        btnDone.titleLabel?.textAlignment = .right
        vAccessory.addSubview(btnDone)
        return vAccessory
    }
    
}

public extension BaseRequest {
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

