//
//  AccountDetailVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/22/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class AccountDetailVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var btnImg: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnRole: UIButton!
    
    @IBOutlet weak var btnBilling: UIButton!
    @IBOutlet weak var btnShipping: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    // MARK: - Private properties
    private var customerDTO: CustomerDTO = CustomerDTO()
    private var lstRole: [DropDownItem] = []
    private var role: String = "" {
        didSet {
            btnRole.setTitle(ECustomerRole(rawValue: role)?.name, for: .normal)
        }
    }
    
    private var _imgPicker: CustomImagePicker!
    
    // MARK: - Properties
    var completed: ((CustomerDTO) -> Void)? = nil
    
    // MARK: - Init
    init(_ customerDTO: CustomerDTO? = nil) {
        super.init()
        if let json = customerDTO?.toJson(), let dto = CustomerDTO.fromJson(json) {
            self.customerDTO = dto
        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "User Info"
        txtEmail.text = customerDTO.email
        txtPassword.text = customerDTO.password
        txtFirstName.text = customerDTO.first_name
        txtLastName.text = customerDTO.last_name
        btnRole.isUserInteractionEnabled = customerDTO.id == nil
        self.role = customerDTO.role ?? ECustomerRole.customer.rawValue
        
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnImg.touchUpInside(block: btnImg_Touched)
        btnUpdate.touchUpInside(block: btnUpdate_Touched)
        btnRole.touchUpInside(block: btnRole_Touched)
        btnBilling.touchUpInside(block: btnBilling_Touched)
        btnShipping.touchUpInside(block: btnShipping_Touched)
        btnHistory.touchUpInside(block: btnHistory_Touched)
    }
    
    // MARK: - Event Handler
    func btnImg_Touched(sender: UIButton) {
        _imgPicker = presentImagePicker()
        _imgPicker?.delegate = self

    }
    
    func btnUpdate_Touched(sender: UIButton) {
        let request = MediaDTO()
        request.base64 = btnImg.currentImage?.toBase64String()
        
        _ = SEMedia.createOrUpdate(request, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
        })
        
//        editCustomer()
        
    }
    
    func btnRole_Touched(sender: UIButton) {
        let roleMenu = UIAlertController(title: "Choose Role", message: nil, preferredStyle: .actionSheet)
        [ECustomerRole.administrator, .author, .contributor, .customer, .editor, .shop_manager, .subscriber].forEach { (role) in
            let action = UIAlertAction(title: role.name, style: .default) { (action) in
                self.role = role.rawValue
            }
            roleMenu.addAction(action)
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        roleMenu.addAction(cancelOption)
        
        if let popoverVCtrl = roleMenu.popoverPresentationController {
            popoverVCtrl.sourceView = sender
            popoverVCtrl.sourceRect = sender.bounds
        }
        
        present(roleMenu, animated: true, completion: nil)
        
    }
    
    func btnBilling_Touched(sender: UIButton) {
        let update = UpdateAddressVCtrl(customerDTO)
        present(update)
    }
    
    func btnShipping_Touched(sender: UIButton) {
        let update = UpdateAddressVCtrl(customerDTO, isBilling: false)
        present(update)

    }
    
    func btnHistory_Touched(sender: UIButton) {
        guard let id = customerDTO.id else { return }
        
        let request = GetOrderRequest(page: 1)
        request.customer = id
        
        _ = SEOrder.getList(request, animation: {
            self.showLoadingView($0)
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            if response.lstOrder.isEmpty {
                _ = self.showWarningAlert(message: "Not have any order")
                return
            }
            
            let order = AccountOrderHistoryVCtrl(response.lstOrder)
            self.navigationController?.pushViewController(order, animated: true)
            
        })
        
        
    }
    
    func present(_ vctrl: BaseVCtrl) {
        let nav = UINavigationController(rootViewController: vctrl)
        nav.navigationBar.isTranslucent = false
        self.present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    func editCustomer() {
        customerDTO.first_name = txtFirstName.text
        customerDTO.last_name = txtLastName.text
        customerDTO.email = txtEmail.text
        customerDTO.password = txtPassword.text
        customerDTO.role = role
        
        task = SECustomer.createOrUpdate(customerDTO, animation: {
            self.showLoadingView($0)
            
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            guard let cusDTO = response.lstCustomer.first else { return }
            self.customerDTO = cusDTO
            self.navigationController?.popViewController(animated: true)
            self.completed?(self.customerDTO)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension AccountDetailVCtrl: CustomImagePickerDelegate {
    func imagePicker(imagePicker: CustomImagePicker, pickedImage: UIImage) {
        imagePicker.imagePickerController.dismiss(animated: true, completion: nil)
        self.btnImg.setImage(pickedImage, for: .normal)
    }
}
