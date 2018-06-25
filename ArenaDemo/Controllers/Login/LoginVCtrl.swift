//
//  LoginVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class LoginVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    // MARK: - Private properties
    
    // MARK: - Properties
    var completed: ((CustomerDTO) -> Void)?
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        addViewToLeftBarItem(view: btnCancel)
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnCancel.touchUpInside(block: btnCancel_Touched)
        btnLogin.touchUpInside(block: btnLogin_Touched)
    }
    
    // MARK: - Event Handler
    func btnCancel_Touched(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func btnLogin_Touched(sender: UIButton) {
        let request = GetCustomerRequest(page: 1)
        request.email = txtEmail.text
    
        _ = SECustomer.getList(request, animation: {
            self.showLoadingView($0)
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }

            guard let dto = response.lstCustomer.first else {
                _ = self.showWarningAlert(message: "Unable to find customer!")
                return
            }
            
            self.dismiss(animated: true, completion: {
                self.completed?(dto)
            })
        })
        
        
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}
