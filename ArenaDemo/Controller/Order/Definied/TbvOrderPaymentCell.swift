//
//  TbvOrderPaymentCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/16/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import CustomControl

class TbvOrderPaymentCell: UITableViewCell {
    
    @IBOutlet weak var vBorder: UIView!
    @IBOutlet weak var lblTempTotal: UILabel!
    @IBOutlet weak var txtCoupon: CustomUITextField!
    @IBOutlet weak var btnApply: UIButton!
    
    @IBOutlet weak var vTotal: UIView!
    @IBOutlet weak var lblTotal: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtCoupon.addTarget(self, action: #selector(self.handleChangeText(_ :)), for: .editingChanged)
        txtCoupon.delegate = self
    }
    
    private var coupon: String? = nil {
        didSet {
            let coupon = self.coupon ?? ""
            btnApply.customEnable(!coupon.isEmpty)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vBorder.layer.applySketchShadow(blur: vBorder.cornerRadius)
    }
    
    func updateCell() {
        lblTempTotal.text = Order.shared.total.toCurrencyString()
        lblTotal.text = Order.shared.total.toCurrencyString()

        coupon = ""
    }
    
    @objc func handleChangeText(_ textField: UITextField) {
        coupon = textField.text
        
    }

}

extension TbvOrderPaymentCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        parentViewController?.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let parent = self.parentViewController as? OrderVCtrl {
            parent.handleFocusInputView(textField)
        }
        
        if let parent = self.parentViewController as? PaymentVCtrl {
            parent.handleFocusInputView(textField)
        }

        return true
    }
    
}
