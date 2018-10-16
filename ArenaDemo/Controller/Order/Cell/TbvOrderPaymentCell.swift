//
//  TbvOrderPaymentCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/16/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import CustomControl
import ArenaDemoAPI

class TbvOrderPaymentCell: UITableViewCell {
    
    @IBOutlet weak var vBorder: UIView!
    @IBOutlet weak var lblTempTotal: UILabel!
    @IBOutlet weak var vCoupon: UIView!
    @IBOutlet weak var txtCoupon: CustomUITextField!
    @IBOutlet weak var btnApply: UIButton!
    
    @IBOutlet weak var vTotal: UIView!
    @IBOutlet weak var lblTotal: UILabel!

    private var order: OrderDTO!
    private var isPayment: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtCoupon.addTarget(self, action: #selector(self.handleChangeText(_ :)), for: .editingChanged)
        txtCoupon.delegate = self
        btnApply.touchUpInside(block: btnApply_Touched)
    }
    
    private var coupon: String? = nil {
        didSet {
            let coupon = self.coupon ?? ""
            txtCoupon.text = coupon
            btnApply.customEnable(!coupon.isEmpty)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vCoupon.cleanSubViews()
        vCoupon.height = 0
    }
    
    func updateCell(_ order: OrderDTO, isPayment: Bool = true) {
        let padding: CGFloat = 15
        self.order = order
        self.isPayment = isPayment
        self.vTotal.isHidden = !isPayment
        lblTempTotal.text = order.subTotal.toCurrencyString()
        lblTotal.text = order.total.toCurrencyString()
        coupon = ""
        
        let heightCoupon: CGFloat = 30
        for (index, element) in order.coupon_lines.enumerated() {
            // txtLabel
            let labelTitle = UILabel()
            labelTitle.text = "Mã giảm giá: \( element.code ?? "" )"
            labelTitle.font = UIFont.systemFont(ofSize: padding, weight: .light)
            labelTitle.textColor = .black
            labelTitle.frame = CGRect(padding, CGFloat(index) * heightCoupon, 200 * Ratio.ratioWidth, heightCoupon)
            vCoupon.addSubview(labelTitle)
            
            // btnDelete
            let btn = UIButton(type: .system)
            btn.setTitle("[Xoá]", for: .normal)
            btn.titleLabel?.font = labelTitle.font
            btn.tintColor = .red
            btn.frame = CGRect(vCoupon.width - 40 - padding, labelTitle.originY, 40, labelTitle.height)
            btn.autoresizingMask = lblTempTotal.autoresizingMask
            btn.accessibilityValue = element.code
            btn.touchUpInside(block: btnRemove_Touched)
            vCoupon.addSubview(btn)
            
            // lblValue
            let labelValue = UILabel()
            labelValue.text = element.discount?.toCurrencyString()
            labelValue.font = UIFont.systemFont(ofSize: padding, weight: .light)
            labelValue.frame = CGRect(btn.originX - lblTempTotal.width, labelTitle.originY, lblTempTotal.width, labelTitle.height)
            labelValue.autoresizingMask = lblTempTotal.autoresizingMask
            labelValue.textAlignment = lblTempTotal.textAlignment
            vCoupon.addSubview(labelValue)
            
            vCoupon.height = vCoupon.subviews.last?.frame.maxY ?? 0
        }
        
        txtCoupon.originY = vCoupon.frame.maxY
        btnApply.originY = txtCoupon.originY
        vBorder.height = btnApply.frame.maxY + padding
        vTotal.originY = vBorder.frame.maxY + padding
        order.coupon_cellHeight = (isPayment ? vTotal.frame.maxY : vBorder.frame.maxY) + padding
        vBorder.layer.applySketchShadow(blur: vBorder.cornerRadius)

    }
    
    @objc func handleChangeText(_ textField: UITextField) {
        coupon = textField.text
    }
    
    func btnApply_Touched(sender: UIButton) {
        guard let parentVCtrl = self.parentViewController as? BaseVCtrl else {
            return
        }

        guard let tableView = self.tableView else {
            return
        }

        let request = GetCouponRequest(page: 1)
        request.code = coupon
        
        _ = SECoupon.getList(request, animation: { (isShow) in
            tableView.showLoadingView(isShow)
            
        }) { (response) in
            if !parentVCtrl.checkResponse(response) {
                return
            }
         
            guard let cp = response.lstCoupon.first else {
                _ = parentVCtrl.showWarningAlert(title: "THÔNG BÁO", message: "Không tồn tại mã giảm giá này", buttonTitle: "OK", action: nil)
                return
            }
            
            guard let msg = self.order.updateCoupon(cp) else {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.vTotal.originY = self.vBorder.frame.maxY + 15
                })
                tableView.reloadData()
                CATransaction.commit()
                return
            }
            
            _ = parentVCtrl.showWarningAlert(title: "THÔNG BÁO", message: msg, buttonTitle: "OK", action: nil)
            self.coupon = ""
        }
    }
    
    func btnRemove_Touched(sender: UIButton) {
        guard let tableView = self.tableView else {
            return
        }
        
        guard let index = order.coupon_lines.index(where: { $0.code == sender.accessibilityValue }) else {
            return
        }
        
        order.coupon_lines.remove(at: index)
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.vTotal.originY = self.vBorder.frame.maxY + 15
        })
        tableView.reloadData()
        CATransaction.commit()
        return
        
    }

}

extension TbvOrderPaymentCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        parentViewController?.view.endEditing(true)
        btnApply.sendActions(for: .touchUpInside)
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

