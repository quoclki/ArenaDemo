//
//  UpdateAddressVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class UpdateAddressVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var vBilling: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    
    // MARK: - Private properties
    private var customerDTO: CustomerDTO!
    private var isBilling: Bool = true
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ customerDTO: CustomerDTO, isBilling: Bool = true) {
        super.init()
        self.customerDTO = customerDTO
        self.isBilling = isBilling
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Address"
        addViewToLeftBarItem(view: btnCancel)
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnUpdate.touchUpInside(block: btnUpdate_Touched)
        btnCancel.touchUpInside(block: btnCancel_Touched)
    }
    
    // MARK: - Event Handler
    func btnUpdate_Touched(sender: UIButton) {
        let addressDTO = AddressDTO()
        addressDTO.first_name = txtFirstName.text ?? ""
        addressDTO.last_name = txtLastName.text ?? ""
        addressDTO.address_1 = txtAddress.text ?? ""
        addressDTO.city = txtCity.text ?? ""
        addressDTO.country = txtCountry.text ?? ""
        addressDTO.phone = txtPhone.text ?? ""
        addressDTO.email = txtEmail.text ?? ""
        addressDTO.company = "ns"
        
        if isBilling {
            customerDTO.billing = addressDTO
        } else {
            customerDTO.shipping = addressDTO
        }
        btnCancel.sendActions(for: .touchUpInside)
        
    }
    
    func btnCancel_Touched(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        let addressDTO = isBilling ? customerDTO.billing : customerDTO.shipping
        txtFirstName.text = addressDTO?.first_name
        txtLastName.text = addressDTO?.last_name
        txtAddress.text = addressDTO?.address_1
        txtCity.text = addressDTO?.city
        txtCountry.text = addressDTO?.country
        txtPhone.text = addressDTO?.phone
        txtEmail.text = addressDTO?.email
        vBilling.isHidden = !self.isBilling
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
