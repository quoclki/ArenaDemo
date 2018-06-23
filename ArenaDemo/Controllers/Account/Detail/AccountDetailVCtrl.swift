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
    
    // MARK: - Private properties
    private var customerDTO: CustomerDTO = CustomerDTO()
    private var lstRole: [DropDownItem] = []
    private var role: String = "" {
        didSet {
            btnRole.setTitle(ECustomerRole(rawValue: role)?.name, for: .normal)
        }
    }
    
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
        txtEmail.text = customerDTO.email
        txtPassword.text = customerDTO.password
        txtFirstName.text = customerDTO.first_name
        txtLastName.text = customerDTO.last_name
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
    }
    
    // MARK: - Event Handler
    func btnImg_Touched(sender: UIButton) {
        
    }
    
    func btnUpdate_Touched(sender: UIButton) {
        editCustomer()
        
    }
    
    func btnRole_Touched(sender: UIButton) {
        let roleMenu = UIAlertController(title: "", message: "Choose Role", preferredStyle: .actionSheet)
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
        customerDTO.billing = nil
        customerDTO.shipping = nil
        
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
