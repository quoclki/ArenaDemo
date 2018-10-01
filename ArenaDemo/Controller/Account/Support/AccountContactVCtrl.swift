//
//  AccountContactVCtrl.swift
//  App Ban Hang
//
//  Created by Lu Kien Quoc on 8/15/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import CustomControl
import ArenaDemoAPI

class AccountContactVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var vInfo: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var vEmail: UIView!
    
    @IBOutlet weak var txtEmail: CustomUITextField!
    @IBOutlet weak var txvNote: UITextView!
    @IBOutlet weak var btnSent: UIButton!
    
    // MARK: - Private properties
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configUIViewInfo()
    }
    
    func configUIViewInfo() {
        vInfo.layer.applySketchShadow(blur: 4)
        vEmail.layer.applySketchShadow(blur: 4)
        btnSent.cornerRadius = btnSent.height / 2
        txvNote.textContainerInset.left = 15
        txvNote.textContainerInset.right = 15

    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: "THÔNG TIN LIÊN HỆ")
        addViewToLeftBarItem(createBackButton())
        txtEmail.delegate = self
        txvNote.delegate = self
        txvNote.inputAccessoryView = Base.getAccessoryKeyboard({
            self.view.endEditing(true)
        })

    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnSent.touchUpInside(block: btnSend_Touched)
    }
    
    // MARK: - Event Handler
    func btnSend_Touched(sender: UIButton) {
        if let email = txtEmail.text?.trim, !email.isEmail {
            txtEmail.text = ""
            _ = showWarningAlert(title: "THÔNG BÁO", message: "Địa chỉ email không hợp lệ", buttonTitle: "OK", action: {
                self.txtEmail.becomeFirstResponder()
            })
            return
        }
        
        if let note = txvNote.text?.trim, note.isEmpty {
            txvNote.text = ""
            _ = showWarningAlert(title: "THÔNG BÁO", message: "Vui lòng nhập nội dung", buttonTitle: "OK", action: {
                self.txvNote.becomeFirstResponder()
            })
            return
        }
        
        _ = showWarningAlert(title: "THÔNG BAÓ", message: "Gửi mail thành công", buttonTitle: "OK", action: nil)
        
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }

}

extension AccountContactVCtrl: HandleKeyboardProtocol, UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        handleFocusInputView(textField)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        handleFocusInputView(textView)
        return true
    }
    
    func handleKeyboard(willShow notify: NSNotification) {
        scrollView.contentSize.height = 0
        self.handleKeyboard(willShow: notify, scv: self.scrollView)
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        scrollView.contentSize.height = 0
        self.handleKeyboard(willHide: notify, scv: self.scrollView)
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

