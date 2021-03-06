//
//  TbvPaymentMethodCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/17/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class TbvPaymentMethodCell: UITableViewCell {

    private var order: OrderDTO!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.cleanSubViews()
    }
    
    func updateCell(_ order: OrderDTO) {
        self.order = order
        
        let vBorder = UIView()
        vBorder.frame = CGRect(15, 15, Ratio.width - 30, 0)
        vBorder.layer.applySketchShadow(blur: vBorder.cornerRadius)
        vBorder.backgroundColor = .white
        vBorder.cornerRadius = 10

        let startY: CGFloat = 7
        var heightForViewBorder: CGFloat = startY
        
        for (_, element) in order.lstPayment.filter({ $0.enabled == true }) .enumerated() {
            let btn = UIButton()
            btn.setImage(UIImage(named: "icon-paymentMethod-notCheck", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
            btn.setImage(UIImage(named: "icon-paymentMethod-check", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .selected)
            btn.frame = CGRect(0, heightForViewBorder, 40, 40)
            btn.touchUpInside(block: btnCheck_Touched)
            btn.isSelected = element.isCheck
            btn.accessibilityValue = element.id
            vBorder.addSubview(btn)
            
            let label = UILabel()
            label.frame = CGRect(btn.frame.maxX, btn.originY, vBorder.width - btn.frame.maxX - 15, btn.height)
            label.text = element.method_title
            label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
            vBorder.addSubview(label)

            heightForViewBorder += btn.height

            if element.isCheck {
                let des = UILabel()
                des.text = element.description
                des.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
                des.numberOfLines = 0
                des.width = label.width
                des.sizeToFit()
                des.frame.origin = CGPoint(label.originX, label.frame.maxY)
                vBorder.addSubview(des)
                heightForViewBorder += des.height
            }
        }
        
        vBorder.height = heightForViewBorder + startY
        self.contentView.addSubview(vBorder)
        order.payment_method_cellHeight = vBorder.frame.maxY + vBorder.originY
        
    }
    
    func btnCheck_Touched(sender: UIButton) {
        if sender.isSelected {
            return
        }
   
        guard let tableView = tableView else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: self) else {
            return
        }
        
        sender.isSelected = !sender.isSelected
        order.lstPayment.forEach { (payment) in
            payment.isCheck = payment.id == sender.accessibilityValue
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        tableView.reloadData()
        CATransaction.commit()
    }
    
}
