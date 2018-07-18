//
//  TbvPaymentInfoCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/17/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import CustomControl
import ArenaDemoAPI

class TbvPaymentInfoCell: UITableViewCell {

    @IBOutlet weak var txtName: CustomUITextField!
    @IBOutlet weak var txtPhone: CustomUITextField!
    @IBOutlet weak var txtEmail: CustomUITextField!
    @IBOutlet weak var txtAddress: CustomUITextField!
    @IBOutlet weak var txvNote: UITextView!
    
    private var item: AddressDTO!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [txtName, txtPhone, txtEmail, txtAddress].forEach({
            $0?.delegate = self
        })
        txvNote.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        txvNote.textContainerInset.left = 15
        txvNote.textContainerInset.right = 15
        
    }
    
    func updateCell(_ item: AddressDTO) {
        self.item = item
        txtName.text = [item.first_name , item.last_name ].filter({ !$0.isEmpty }).joined(separator: " ")
        txtPhone.text = item.phone
        txtEmail.text = item.email
        txtAddress.text = item.address_1

    }
    
}

extension TbvPaymentInfoCell: UITextFieldDelegate, UITextViewDelegate {
    
    func handleBeginEditing(_ vFocus: UIView) {
        if let parent = self.parentViewController as? PaymentVCtrl {
            parent.handleFocusInputView(vFocus)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        handleBeginEditing(textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.parentViewController?.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        if textField == txtName {
            self.item.first_name = text
            return
        }
        
        if textField == txtPhone {
            self.item.phone = text
            return
        }
        
        if textField == txtEmail {
            self.item.email = text
            return
        }
        
        if textField == txtAddress {
            self.item.address_1 = text
            return
        }
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        handleBeginEditing(textView)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text, !text.isEmpty else {
            return
        }
        
        if let parent = self.parentViewController as? PaymentVCtrl {
            parent.order.customer_note = text
        }

    }
    
    
}
