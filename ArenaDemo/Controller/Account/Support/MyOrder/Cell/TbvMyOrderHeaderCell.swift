//
//  TbvMyOrderHeaderCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/23/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class TbvMyOrderHeaderCell: UITableViewCell {

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblStatus.clipsToBounds = true
        lblStatus.cornerRadius = lblStatus.height / 2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ item: OrderDTO) {
        lblOrderNo.text = "ĐƠN HÀNG: #\( item.number ?? "" )"
        lblDate.text = "Đặt ngày \( item.date_created_gmt?.string("dd/MM/yyyy", localeID: MultiLanguage.shared.currentLocale) ?? "")"
        let eStatus = EOrderStatus(rawValue: item.status ?? "")
        lblStatus.text = eStatus?.name.uppercased()
        lblStatus.backgroundColor = eStatus?.color
        
    }
    
}
