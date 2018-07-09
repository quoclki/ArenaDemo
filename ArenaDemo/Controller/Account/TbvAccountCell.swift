//
//  TbvAccountCell.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/9/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit

class TbvAccountCell: UITableViewCell {

    @IBOutlet weak var vSignInSignUp: UIView!
    @IBOutlet weak var vCell: UIView!
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
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
        btnSignIn.cornerRadius = btnSignIn.height / 2
        btnSignUp.cornerRadius = btnSignUp.height / 2
        
        guard let account = self.parentViewController as? AccountVCtrl else {
            return
        }
        btnSignIn.touchUpInside(block: account.btnSignIn_Touched)
        btnSignUp.touchUpInside(block: account.btnSignUp_Touched)
        
    }
    
    func updateCell(_ item: EAccountMenu) {
        vSignInSignUp.isHidden = item != .signInSignUp
        vCell.isHidden = !vSignInSignUp.isHidden
        lblName.text = item.name
        imvIcon.image = item.icon

    }
    
    
    
}
