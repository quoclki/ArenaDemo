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
    
    private var lstTextField: [UITextField] = []
    
    // MARK: - Properties
    var handleCompleted: (() -> Void)? = nil
    
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
        self.lstTextField = [txtName, txtEmail, txtPassword, txtPasswordNew, txtPasswordNewConfirm]
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
        
        lstTextField.forEach({
            $0.delegate = self
        })
    }
    
    // MARK: - Event Handler
    func btnSave_Touched(sender: UIButton) {
        view.endEditing(true)
        guard let name = txtName.text, !name.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập họ tên", buttonTitle: "OK", action: {
                self.txtName.text = ""
                self.txtName.becomeFirstResponder()
            })
            return
        }
        
        guard let email = txtEmail.text, !email.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập email", buttonTitle: "OK", action: {
                self.txtEmail.text = ""
                self.txtEmail.becomeFirstResponder()
            })
            return
        }

        guard let pass = txtPassword.text, !pass.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập mật khẩu hiện tại", buttonTitle: "OK", action: {
                self.txtPassword.text = ""
                self.txtPassword.becomeFirstResponder()
            })
            return
        }

        guard let passNew = txtPasswordNew.text, !passNew.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập mật khẩu mới", buttonTitle: "OK", action: {
                self.txtPasswordNew.text = ""
                self.txtPasswordNew.becomeFirstResponder()
            })
            return
        }

        guard let passNewConfirm = txtPasswordNewConfirm.text, !passNewConfirm.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập xác nhận mật khẩu", buttonTitle: "OK", action: {
                self.txtPasswordNewConfirm.text = ""
                self.txtPasswordNewConfirm.becomeFirstResponder()
            })
            return
        }

        if passNewConfirm != passNew {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập xác nhận mật khẩu giống mật khẩu mới", buttonTitle: "OK", action: {
                self.txtPasswordNewConfirm.text = ""
                self.txtPasswordNewConfirm.becomeFirstResponder()
            })
            return
        }

        func updateAccount() {
            guard let request = CustomerDTO.fromJson(cusDTO.toJson()) else {
                return
            }
            
            request.first_name = name
            request.email = email
            request.password = passNew
            
            _ = SECustomer.createOrUpdate(request, animation: {
                self.showLoadingView($0, frameLoading: self.vSafe.frame)
                self.vBar.isUserInteractionEnabled = !$0

            }, completed: { (response) in
                if !self.checkResponse(response) {
                    return
                }

                guard let cusDTO = response.lstCustomer.first else {
                    _ = self.showWarningAlert(title: "Cảnh báo", message: "Không thể lưu thông tin!")
                    return
                }

                Order.shared.updateCusDTO(cusDTO)
                self.navigationController?.popViewController(animated: true)
                self.handleCompleted?()
            })
            
        }
        
        getAuthDTO(cusDTO.username, password: pass) {_ in
            updateAccount()
        }
        
    }
    
    
    func btnSignOut_Touched(sender: UIButton) {
        Order.shared.cusDTO = CustomerDTO()
        UserDefaults.standard.removeObject(forKey: EUserDefaultKey.customerInfo.rawValue)
        navigationController?.popViewController(animated: true)
        handleCompleted?()
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
        self.scrollView.contentSize.height = 0
        self.handleKeyboard(willShow: notify, scv: self.scrollView)
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        self.scrollView.contentSize.height = 0
        self.handleKeyboard(willHide: notify, scv: self.scrollView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldNotInputData()
        return true
    }
    
    func handleTextFieldNotInputData() {
        if let tf = self.lstTextField.first(where: { ($0.text ?? "").isEmpty }) {
            tf.becomeFirstResponder()
            
        } else {
            self.view.endEditing(true)
            self.btnSave.sendActions(for: .touchUpInside)
            
        }
        
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

