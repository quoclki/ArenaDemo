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
    
    @IBOutlet var vKeyboardAccessory: UIView!
    @IBOutlet var btnDone: UIButton!
    
    // MARK: - Private properties
    private var pageDTO: PageDTO = PageDTO()
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ pageDTO: PageDTO) {
        super.init()
        self.pageDTO = pageDTO
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configUIViewInfo()
    }
    
    func configUIViewInfo() {
        vInfo.layer.applySketchShadow(blur: 4)
        vEmail.layer.applySketchShadow(blur: 4)
        btnSent.cornerRadius = btnSent.height / 2
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: "THÔNG TIN LIÊN HỆ")
        addViewToLeftBarItem(createBackButton())
        lblInfo.attributedText = self.pageDTO.content?.rendered?.htmlAttribute
        txtEmail.delegate = self
        txvNote.delegate = self
        txvNote.inputAccessoryView = vKeyboardAccessory

    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnDone.touchUpInside(block: btnDone_Touched)
    }
    
    // MARK: - Event Handler
    
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

    func btnDone_Touched(sender: UIButton) {
        view.endEditing(true)
    }
    
    func handleKeyboard(willShow notify: NSNotification) {
        self.handleKeyboard(willShow: notify, scv: self.scrollView)
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
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

