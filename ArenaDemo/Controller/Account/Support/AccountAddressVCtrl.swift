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
        
        [txtShippingName, txtShippingPhone, txtShippingEmail, txtShippingAddress, txtBillingName, txtBillingPhone, txtBillingEmail, txtBillingAddress].forEach({
            $0?.delegate = self
        })

    }
    
    // MARK: - Event Handler
    func btnSave_Touched(sender: UIButton) {
        view.endEditing(true)

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
            self.showLoadingView($0)
            
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
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}

extension AccountAddressVCtrl: HandleKeyboardProtocol, UITextFieldDelegate {
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

