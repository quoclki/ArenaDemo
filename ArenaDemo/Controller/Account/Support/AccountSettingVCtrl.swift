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
        configUIViewInfo()
    }
    
    func configUIViewInfo() {
        vTitle.layer.applySketchShadow(blur: 4)
        vInfo.size = self.scrollView.size
        vInfo.origin = CGPoint.zero
        self.scrollView.addSubview(vInfo)
        self.scrollView.contentSize.height = vInfo.height

    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: "CÀI ĐẶT TÀI KHOẢN")
        addViewToLeftBarItem(createBackButton())
        mappingViewInfo()
        
    }
    
    func mappingViewInfo() {
        let dto = Order.shared.cusDTO
        txtName.text = dto.first_name
        txtEmail.text = dto.email
        
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnSave.touchUpInside(block: btnSave_Touched)
        btnSignOut.touchUpInside(block: btnSignOut_Touched)
        
        [txtName, txtEmail, txtPassword, txtPasswordNew, txtPasswordNewConfirm].forEach({
            $0?.delegate = self
        })
    }
    
    // MARK: - Event Handler
    func btnSave_Touched(sender: UIButton) {
        
    }
    
    func btnSignOut_Touched(sender: UIButton) {
        
        
        
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}

extension AccountSettingVCtrl: HandleKeyboardProtocol, UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        handleFocusInputView(textField)
        return true
    }
    
    func handleKeyboard(willShow notify: NSNotification) {
        self.handleKeyboard(willShow: notify, scv: self.scrollView)
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        self.handleKeyboard(willHide: notify, scv: self.scrollView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleKeyboard(register: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleKeyboard(register: false)
    }
    
    
}

