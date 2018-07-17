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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [txtName, txtPhone, txtEmail, txtAddress].forEach({_ in
//            $0?.delegate = self
        })

    }
    
    func updateCell(_ item: AddressDTO?) {
        txtName.text = [item?.first_name ?? "", item?.last_name ?? ""].filter({ !$0.isEmpty }).joined(separator: " ")
        txtPhone.text = item?.phone
        txtEmail.text = item?.email
        txtAddress.text = item?.address_1

    }
    
}
