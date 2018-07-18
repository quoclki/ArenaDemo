//
//  AccountVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/6/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class AccountVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var vLogo: UIView!
    @IBOutlet weak var imvLogo: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vBorder: UIView!
    @IBOutlet weak var tbvAccount: UITableView!
    @IBOutlet var vSignUpSignIn: UIView!
    
    // View Sign In - Sign Up
    @IBOutlet weak var btnSignUpDetail: UIButton!
    @IBOutlet weak var btnSignInDetail: UIButton!
    @IBOutlet weak var vMark: UIView!
    
    @IBOutlet weak var vSignUpDetail: UIView!
    @IBOutlet weak var txtSignUpUserName: CustomUITextField!
    @IBOutlet weak var txtSignUpPassword: CustomUITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnCheckRemember: UIButton!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var btnSignUpConfirm: UIButton!
    
    @IBOutlet weak var vSignInDetail: UIView!
    @IBOutlet weak var txtSignInEmail: CustomUITextField!
    @IBOutlet weak var txtSignInPassword: CustomUITextField!
    @IBOutlet weak var txtSignInConfirmPassword: CustomUITextField!
    @IBOutlet weak var btnSignInConfirm: UIButton!
    
    // MARK: - Private properties
    private var lstItem: [EAccountMenu] = []
    private var btnBack: UIButton!
    private var isBack: Bool = false {
        didSet {
            btnBack.isHidden = !isBack
            vSignUpSignIn.isHidden = btnBack.isHidden
            tbvAccount.isHidden = !vSignUpSignIn.isHidden
        }
    }
    
    private var isSignUp: Bool = false {
        didSet {
            self.view.endEditing(true)
            vMark.originX = isSignUp ? btnSignUpDetail.originX : btnSignInDetail.originX
            vMark.originY = btnSignUpDetail.height
            UIView.animate(withDuration: 0.3) {
                self.vMark.originY = self.btnSignUpDetail.height - self.vMark.height
            }
            
            vSignUpDetail.isHidden = !isSignUp
            vSignInDetail.isHidden = !vSignUpDetail.isHidden
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        vLogo.height = vLogo.width
        vLogo.cornerRadius = vLogo.width / 2
        btnSignUpConfirm.cornerRadius = btnSignUpConfirm.height / 2
        btnSignInConfirm.cornerRadius = btnSignInConfirm.height / 2
        vMark.width = btnSignUpDetail.width
        vBorder.dropShadow(color: UIColor(hexString: "DEDEDE"), offSet: CGSize(5,5), radius: vBorder.cornerRadius)
        vBorder.layer.applySketchShadow(blur: vBorder.cornerRadius)
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(title: "TÀI KHOẢN")
        vSetSafeArea = vSafe
        setupUIForAccount()
        configTableView()
        scrollView.delegate = self
    }
    
    func setupUIForAccount() {
        btnBack = createBackButton(80) { sender in
            self.isBack = false
        }
        vBar.addSubview(btnBack)
        imvLogo.contentMode = .scaleAspectFill
        
        vSignUpSignIn.size = vBorder.size
        vMark.backgroundColor = Base.baseColor
        vBorder.addSubview(vSignUpSignIn)
        configDefaultAccount()
    }
    
    func configDefaultAccount() {
        isBack = false
        ImageStore.shared.setImg(toImageView: imvLogo, imgURL: Order.shared.cusDTO.avatar_url, defaultImg: Base.logo)
        let cusDTO = Order.shared.cusDTO
        if let _ = Order.shared.cusDTO.id {
            lstItem = [.myOrder, .favourite, .address, .storeSystem, .orderCondition, .accSetting]
            lblName.text = [cusDTO.first_name ?? "", cusDTO.last_name ?? ""].joined(separator: " ")
        } else {
            lstItem = [.myOrder, .favourite, .orderCondition, .storeSystem, .contactInfo, .signInSignUp]
            lblName.text = "APP BÁN HÀNG"
        }
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnSignInDetail.touchUpInside(block: btnSignInDetail_Touched)
        btnSignInConfirm.touchUpInside(block: btnSignInConfirm_Touched)
        btnSignUpDetail.touchUpInside(block: btnSignUpDetail_Touched)
        btnSignUpConfirm.touchUpInside(block: btnSignUpConfirm_Touched)
        
        [txtSignUpUserName, txtSignUpPassword, txtSignInEmail, txtSignInPassword, txtSignInConfirmPassword].forEach({
            $0?.delegate = self
        })
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}

extension AccountVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    private var cellID: String {
        return "tbvAccountCellID"
    }
    
    func configTableView() {
        tbvAccount.register(UINib(nibName: String(describing: TbvAccountCell.self), bundle: Bundle(for: Base.self)), forCellReuseIdentifier: cellID)
        tbvAccount.dataSource = self
        tbvAccount.delegate = self
        tbvAccount.isScrollEnabled = false
        tbvAccount.separatorInset.left = 15
        tbvAccount.separatorInset.right = 15
        tbvAccount.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvAccountCell
        let item = lstItem[indexPath.row]
        cell.updateCell(item)
        cell.selectionStyle = item == .signInSignUp ? .none : .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / CGFloat(lstItem.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = lstItem[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: item != .signInSignUp)
        
        
    }
    
}

// Handle Sign in - Sign Up
extension AccountVCtrl {
    func btnSignIn_Touched(sender: UIButton) {
        isBack = true
        isSignUp = false
    }
    
    func btnSignInDetail_Touched(sender: UIButton) {
        isSignUp = false
    }
    
    func btnSignInConfirm_Touched(sender: UIButton) {
        guard let email = txtSignInEmail.text?.trim(), !email.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập email", buttonTitle: "OK") {
                self.txtSignInEmail.becomeFirstResponder()
            }
            return
        }
        
        guard let password = txtSignInPassword.text, !password.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập mật khẩu", buttonTitle: "OK") {
                self.txtSignInPassword.becomeFirstResponder()
            }
            return
        }
        
        guard let confirmPassword = txtSignInConfirmPassword.text, !confirmPassword.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập xác nhận mật khẩu", buttonTitle: "OK") {
                self.txtSignInConfirmPassword.becomeFirstResponder()
            }
            return
        }
        
        if password != confirmPassword {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập xác nhận mật khẩu giống mật khẩu", buttonTitle: "OK")
            return

        }

        let request = CustomerDTO()
//        request.first_name = txtFirstName.text
//        request.last_name = txtLastName.text
        request.email = email
        request.password = password
        request.role = ECustomerRole.customer.rawValue
        
        task = SECustomer.createOrUpdate(request, animation: {
            self.showLoadingView($0)
            
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            guard let cusDTO = response.lstCustomer.first else { return }
            Order.shared.cusDTO = cusDTO
            _ = self.showWarningAlert(title: "Thông báo", message: "ĐĂNG KÍ THÀNH CÔNG", buttonTitle: "OK") {
                self.configDefaultAccount()
                self.tbvAccount.reloadData()
                
            }

        }

        
    }
    
    func btnSignUp_Touched(sender: UIButton) {
        isBack = true
        isSignUp = true
        
    }
    
    func btnSignUpDetail_Touched(sender: UIButton) {
        isSignUp = true
    }
    
    func btnSignUpConfirm_Touched(sender: UIButton) {
        guard let userName = txtSignUpUserName.text?.trim(), !userName.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập email", buttonTitle: "OK") {
                self.txtSignUpUserName.becomeFirstResponder()
            }
            return
        }
        
        guard let password = txtSignUpPassword.text, !password.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập mật khẩu", buttonTitle: "OK") {
                self.txtSignUpPassword.becomeFirstResponder()
            }
            return
        }

        let request = GetAuthRequest()
        request.username = userName
        request.password = password
        
        task = SEAuth.authentication(request, animation: {
            self.showLoadingView($0, frameLoading: self.vSafe.frame)
            self.vBar.isUserInteractionEnabled = !$0
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            guard let email = response.authDTO?.user?.email else { return }
            self.getCustomerDTO(email)
        })

    }
 
    func getCustomerDTO(_ email: String) {
        let request = GetCustomerRequest(page: 1)
        request.email = email
        request.role = ECustomerRole.all.rawValue
        
        task = SECustomer.getList(request, animation: {
            self.showLoadingView($0, frameLoading: self.vSafe.frame)
            self.vBar.isUserInteractionEnabled = !$0
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            guard let cusDTO = response.lstCustomer.first else { return }
            Order.shared.cusDTO = cusDTO
            _ = self.showWarningAlert(title: "Thông báo", message: "ĐĂNG NHẬP THÀNH CÔNG", buttonTitle: "OK") {
                self.configDefaultAccount()
                self.tbvAccount.reloadData()
                
            }
            
            
        })
        
    }

    
}

extension AccountVCtrl: HandleKeyboardProtocol, UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        handleFocusInputView(textField)
        return true
    }

    func handleKeyboard(willShow notify: NSNotification) {
        self.handleKeyboard(willShow: notify, scv: self.scrollView)
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        scrollView.setContentOffset(CGPoint(0, self.yOffset), animated: true)
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


enum EAccountMenu: Int {
    case myOrder
    case favourite
    case address
    case storeSystem
    case orderCondition
    case accSetting
    case contactInfo
    case signInSignUp
    
    var name: String {
        switch self {
        case .myOrder:
            return "Đơn Hàng Của Tôi"
            
        case .favourite:
            return "Danh Sách Ưa Thích"
            
        case .address:
            return "Địa Chỉ"
            
        case .storeSystem:
            return "Hệ Thống Cửa Hàng"
            
        case .orderCondition:
            return "Chính Sách Mua Hàng"
            
        case .accSetting:
            return "Cài Đặt Tài Khoản"
            
        case .contactInfo:
            return "Thông Tin Liên Hệ"
            
        default:
            return ""
        }
    }
    
    var icon: UIImage {
        return UIImage(named: "icon-" + String(describing: self), in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
    }
}
