//
//  AccountSettingVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/18/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import CustomControl
import ArenaDemoAPI

class AccountSettingVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var vInfo: UIView!
    @IBOutlet weak var vTitle: UIView!
    @IBOutlet weak var txtName: CustomUITextField!
    @IBOutlet weak var txtEmail: CustomUITextField!
    @IBOutlet weak var txtPassword: CustomUITextField!
    @IBOutlet weak var txtPasswordNew: CustomUITextField!
    @IBOutlet weak var txtPasswordNewConfirm: CustomUITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnSignOut: UIButton!
    
    // MARK: - Private properties
    private var cusDTO: CustomerDTO {
        return Order.shared.cusDTO
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        btnSave.cornerRadius = btnSave.height / 2
        btnSignOut.cornerRadius = btnSignOut.height / 2

    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(title: "CÀI ĐẶT TÀI KHOẢN")
        vSetSafeArea = vSafe
        addViewToLeftBarItem(createBackButton())
        setupViewInfo()
        
    }
    
    func setupViewInfo() {
        vInfo.width = self.scrollView.width
        vInfo.origin = CGPoint.zero
        self.scrollView.addSubview(vInfo)
        self.scrollView.contentSize.height = vInfo.height

        vTitle.layer.applySketchShadow(blur: 4)

    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}
