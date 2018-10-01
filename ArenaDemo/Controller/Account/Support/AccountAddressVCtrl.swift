//
//  AccountAddressVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/18/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import CustomControl
import ArenaDemoAPI

class AccountAddressVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet var vInfo: UIView!
    @IBOutlet weak var vShippingTitle: UIView!
    @IBOutlet weak var txtShippingName: CustomUITextField!
    @IBOutlet weak var txtShippingPhone: CustomUITextField!
    @IBOutlet weak var txtShippingEmail: CustomUITextField!
    @IBOutlet weak var txtShippingAddress: CustomUITextField!
    
    @IBOutlet weak var vBillingTitle: UIView!
    @IBOutlet weak var txtBillingName: CustomUITextField!
    @IBOutlet weak var txtBillingPhone: CustomUITextField!
    @IBOutlet weak var txtBillingEmail: CustomUITextField!
    @IBOutlet weak var txtBillingAddress: CustomUITextField!
    
    // MARK: - Private properties
    private var cusDTO: CustomerDTO {
        return Order.shared.cusDTO
    }
    
    private var lstTextField: [UITextField] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configUIViewInfo()
    }
    
    func configUIViewInfo() {
        vShippingTitle.layer.applySketchShadow(blur: 4)
        vBillingTitle.layer.applySketchShadow(blur: 4)
        vInfo.origin = CGPoint.zero
        vInfo.width = self.scrollView.width
        if vInfo.height < scrollView.height {
            vInfo.height = scrollView.height
        }
        
        self.scrollView.addSubview(vInfo)
        self.scrollView.contentSize.height = vInfo.height
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: "ĐỊA CHỈ")
        addViewToLeftBarItem(createBackButton())
        mappingViewInfo()
    }
    
    func mappingViewInfo() {
        lstTextField = [txtShippingName, txtShippingPhone, txtShippingEmail, txtShippingAddress, txtBillingName, txtBillingPhone, txtBillingEmail, txtBillingAddress]
        txtShippingName.text = cusDTO.shipping?.first_name
        txtShippingPhone.text = cusDTO.shipping?.phone
        txtShippingEmail.text = cusDTO.shipping?.email
        txtShippingAddress.text = cusDTO.shipping?.address_1
        
        txtBillingName.text = cusDTO.billing?.first_name
        txtBillingPhone.text = cusDTO.billing?.phone
        txtBillingEmail.text = cusDTO.billing?.email
        txtBillingAddress.text = cusDTO.billing?.address_1
        
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnSave.touchUpInside(block: btnSave_Touched)
        
        lstTextField.forEach({
            $0.delegate = self
        })

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapScrollView))
        scrollView.addGestureRecognizer(tapGesture)
        
    }
    
    // MARK: - Event Handler
    @objc func handleTapScrollView() {
        self.view.endEditing(true)
    }
    
    func btnSave_Touched(sender: UIButton) {
        view.endEditing(true)

        if !validateInfo() {
            return
        }
        
        guard let request = CustomerDTO.fromJson(cusDTO.toJson()) else {
            return
        }
        
        let shipping = AddressDTO()
        shipping.first_name = txtShippingName.text ?? ""
        shipping.phone = txtShippingPhone.text ?? ""
        shipping.email = txtShippingEmail.text ?? ""
        shipping.address_1 = txtShippingAddress.text ?? ""
        
        let billing = AddressDTO()
        billing.first_name = txtBillingName.text ?? ""
        billing.phone = txtBillingPhone.text ?? ""
        billing.email = txtBillingEmail.text ?? ""
        billing.address_1 = txtBillingAddress.text ?? ""
        
        request.shipping = shipping
        request.billing = billing
        
        _ = SECustomer.createOrUpdate(request, animation: {
            self.view.showLoadingView($0)
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            guard let dto = response.lstCustomer.first else {
                _ = self.showWarningAlert(title: "Cảnh báo", message: "Không thể lưu thông tin!")
                return
            }
            
            Order.shared.updateCusDTO(dto)
            self.navigationController?.popViewController(animated: true)
            
        })
        
    }
    
    func validateInfo() -> Bool {
        // SHIPPING
        var msgShippingArray: [String] = []
        if let firstName = txtShippingName.text?.trim, firstName.isEmpty {
            txtShippingName.text = ""
            msgShippingArray.append("Họ tên trống")
        }
        
        if let phone = txtShippingPhone.text?.trim, phone.isEmpty {
            txtShippingPhone.text = ""
            msgShippingArray.append("Điện thoại trống")
        }
        
        if let email = txtShippingEmail.text?.trim, !email.isEmail {
            txtShippingEmail.text = ""
            msgShippingArray.append("Email sai định dạng")
        }
        
        if let address = txtShippingAddress.text?.trim, address.isEmpty {
            txtShippingAddress.text = ""
            msgShippingArray.append("Địa chỉ trống")
        }
        
        // BILLING
        var msgBillingArray: [String] = []
        if let firstName = txtBillingName.text?.trim, firstName.isEmpty {
            txtBillingName.text = ""
            msgBillingArray.append("Họ tên trống")
        }
        
        if let phone = txtBillingPhone.text?.trim, phone.isEmpty {
            txtBillingPhone.text = ""
            msgBillingArray.append("Điện thoại trống")
        }
        
        if let email = txtBillingEmail.text?.trim, !email.isEmail {
            txtBillingEmail.text = ""
            msgBillingArray.append("Email sai định dạng")
        }
        
        if let address = txtBillingAddress.text?.trim, address.isEmpty {
            txtBillingAddress.text = ""
            msgBillingArray.append("Địa chỉ trống")
        }
        
        var msgArray: [String] = []
        if !msgShippingArray.isEmpty {
            msgArray.append("ĐỊA CHỈ GIAO HÀNG: " + msgShippingArray.joined(separator: ", "))
        }

        if !msgBillingArray.isEmpty {
            msgArray.append("ĐỊA CHỈ THANH TOÁN: " + msgBillingArray.joined(separator: ", "))
        }

        if !msgArray.isEmpty {
            _ = showWarningAlert(title: "THÔNG BÁO", message: msgArray.joined(separator: "\n"), buttonTitle: "OK", action: {
                self.handleTextFieldNotInputData()
            })
            return false
        }
        
        return true
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
}

extension AccountAddressVCtrl: HandleKeyboardProtocol, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if [txtBillingPhone, txtShippingPhone].contains(textField) && string != "" {
            return string.isNumber
        }

        return true
    }
    
    func handleTextFieldNotInputData() {
        if let tf = self.lstTextField.first(where: { ($0.text ?? "").isEmpty }) {
            tf.becomeFirstResponder()
            
        } else {
            self.view.endEditing(true)
        }
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        handleFocusInputView(textField)
        
        if [txtBillingPhone, txtShippingPhone].contains(textField) {
            textField.inputAccessoryView = Base.getAccessoryKeyboard({
                if !(textField.text ?? "").isEmpty {
                    self.handleTextFieldNotInputData()
                }
            })
        }

        return true
    }
    
    func handleKeyboard(willShow notify: NSNotification) {
        self.scrollView.contentSize.height = vInfo.height
        self.handleKeyboard(willShow: notify, scv: self.scrollView)
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        self.scrollView.contentSize.height = vInfo.height
        self.handleKeyboard(willHide: notify, scv: self.scrollView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldNotInputData()
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

