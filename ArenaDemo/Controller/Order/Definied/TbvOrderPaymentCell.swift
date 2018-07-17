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
    }
    
    private var coupon: String? = nil {
        didSet {
            let coupon = self.coupon ?? ""
            btnApply.customEnable(!coupon.isEmpty)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        txtCoupon.addTarget(self, action: #selector(self.handleChangeText(_ :)), for: .editingChanged)
        txtCoupon.delegate = self
        vBorder.dropShadow(color: UIColor(hexString: "DEDEDE"), offSet: CGSize(5,5), radius: vBorder.cornerRadius)
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
}
