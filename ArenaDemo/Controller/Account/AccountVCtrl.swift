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
    @IBOutlet weak var btnSignInDetail: UIButton!
    @IBOutlet weak var btnSignUpDetail: UIButton!
    @IBOutlet weak var vMark: UIView!

    @IBOutlet weak var vSignInDetail: UIView!
    @IBOutlet weak var txtSignInName: CustomUITextField!
    @IBOutlet weak var txtSignInPassword: CustomUITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnCheckRemember: UIButton!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var btnSignInConfirm: UIButton!

    @IBOutlet weak var vSignUpDetail: UIView!
    @IBOutlet weak var txtSignUpEmail: CustomUITextField!
    @IBOutlet weak var txtSignUpPassword: CustomUITextField!
    @IBOutlet weak var txtSignUpConfirmPassword: CustomUITextField!
    @IBOutlet weak var btnSignUpConfirm: UIButton!
    
    // MARK: - Private properties
    private var lstItem: [EAccountMenu] = []
    private var btnBack: UIButton!
    private var isBack: Bool = false {
        didSet {
            self.view.endEditing(true)
            btnBack.isHidden = !isBack
            vSignUpSignIn.isHidden = btnBack.isHidden
            tbvAccount.isHidden = !vSignUpSignIn.isHidden
        }
    }
    
    private var isSignIn: Bool = false {
        didSet {
            self.view.endEditing(true)
            vMark.originX = isSignIn ? btnSignInDetail.originX : btnSignUpDetail.originX
            vMark.originY = btnSignUpDetail.height
            UIView.animate(withDuration: 0.3) {
                self.vMark.originY = self.btnSignUpDetail.height - self.vMark.height
            }

            vSignInDetail.isHidden = !isSignIn
            vSignUpDetail.isHidden = !vSignInDetail.isHidden
        }
    }
    
    private var storeDataDTO: PageDTO?
    private var policyDataDTO: PageDTO?
    private var contactDataDTO: PageDTO?
    
    private var lstTextFieldSignUp: [UITextField] = []
    private var lstTextFieldSignIn: [UITextField] = []
    
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
        createNavigationBar(vSafe, title: "TÀI KHOẢN")
        setupUIForAccount()
        configTableView()
        scrollView.delegate = self
        lstTextFieldSignUp = [txtSignUpEmail, txtSignUpPassword, txtSignUpConfirmPassword]
        lstTextFieldSignIn = [txtSignInName, txtSignInPassword]
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
            lstItem = [.myOrder, .favorite, .address, .storeSystem, .orderCondition, .accSetting]
            lblName.text = cusDTO.email
            if let firstName = cusDTO.first_name, !firstName.isEmpty {
                lblName.text = firstName
            }
        } else {
            lstItem = [.myOrder, .favorite, .orderCondition, .storeSystem, .contactInfo, .signInSignUp]
            lblName.text = "APP BÁN HÀNG"
        }
        lstTextFieldSignUp.forEach({
            $0.text = ""
        })
        lstTextFieldSignIn.forEach({
            $0.text = ""
        })
        btnCheck.isSelected = false
        self.tbvAccount.reloadData()
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        Base.container.setHiddenAnimationMenu(false)
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnSignInDetail.touchUpInside(block: btnSignInDetail_Touched)
        btnSignInConfirm.touchUpInside(block: btnSignInConfirm_Touched)
        btnSignUpDetail.touchUpInside(block: btnSignUpDetail_Touched)
        btnSignUpConfirm.touchUpInside(block: btnSignUpConfirm_Touched)

        lstTextFieldSignUp.forEach({
            $0.delegate = self
        })
        
        lstTextFieldSignIn.forEach({
            $0.delegate = self
        })

        btnCheck.touchUpInside(block: btnCheck_Touched)
        btnCheckRemember.touchUpInside(block: btnCheck_Touched)
    }
    
    // MARK: - Event Handler
    func btnCheck_Touched(sender: UIButton) {
        btnCheck.isSelected = !btnCheck.isSelected
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}

extension AccountVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    private var cellID: String {
        return String(describing: TbvAccountCell.self)
    }
    
    func configTableView() {
        tbvAccount.register(UINib(nibName: cellID, bundle: Bundle(for: Base.self)), forCellReuseIdentifier: cellID)
        tbvAccount.dataSource = self
        tbvAccount.delegate = self
        tbvAccount.isScrollEnabled = false
        tbvAccount.backgroundColor = .clear
        tbvAccount.separatorStyle = .none
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
        
        switch item {
        case .myOrder:
            if Order.shared.cusDTO.id == nil {
                Base.container.tab = .order
                return
            }
            
            pushMyOrder()
            
        case .favorite:
            let lstItem = FavoriteData.shared.lstItem
            if lstItem.isEmpty {
                _ = showWarningAlert(title: "THÔNG BÁO", message: "Không có sản phẩm yêu thích", buttonTitle: "OK", action: nil)
                return
            }
            
            let request = GetProductRequest(page: 1)
            request.include = lstItem.map({ $0 })
            
            _ = SEProduct.getListProduct(request, animation: {
                self.view.showLoadingView($0)

            }, completed: { (response) in
                if !self.checkResponse(response) {
                    return
                }
                
                let favorite = AccountFavoriteVCtrl(response.lstProduct)
                self.navigationController?.pushViewController(favorite, animated: true)

            })

            return
            
        case .orderCondition:
            let title = RenderDTO()
            title.rendered = "Chính sách mua hàng"

            let dto = PageDTO()
            dto.title = title
            dto.slug = "chinh-sach"
            pushAccountShowInfo(dto)
            
//            if let dto = policyDataDTO {
//                pushAccountShowInfo(dto)
//                return
//            }
//
//            let request = GetPageRequest(page: 1)
//            request.per_page = 1
//            request.slug = "chinh-sach"
//
//            _ = SEPage.getList(request, animation: {
//                self.showLoadingView($0)
//
//            }, completed: { (response) in
//                if !self.checkResponse(response) {
//                    return
//                }
//
//                guard let dto = response.lstPage.first else {
//                    _ = self.showWarningAlert(message: "Unable to find page")
//                    return
//                }
//                self.policyDataDTO = dto
//                self.pushAccountShowInfo(dto)
//
//            })
            
        case .storeSystem:
            let title = RenderDTO()
            title.rendered = "Danh sách cửa hàng"
            
            let dto = PageDTO()
            dto.title = title
            dto.slug = "cua-hang"
            pushAccountShowInfo(dto)

//            if let dto = storeDataDTO {
//                pushAccountShowInfo(dto)
//                return
//            }
//
//            let request = GetPageRequest(page: 1)
//            request.per_page = 1
//            request.slug = "cua-hang"
//
//            _ = SEPage.getList(request, animation: {
//                self.showLoadingView($0)
//
//            }, completed: { (response) in
//                if !self.checkResponse(response) {
//                    return
//                }
//
//                guard let dto = response.lstPage.first else {
//                    _ = self.showWarningAlert(message: "Unable to find page")
//                    return
//                }
//                self.storeDataDTO = dto
//                self.pushAccountShowInfo(dto)
//
//            })
            
        case .contactInfo:
            let contact = AccountContactVCtrl()
            navigationController?.pushViewController(contact, animated: true)

//            func pushContact(_ dto: PageDTO) {
//                let contact = AccountContactVCtrl(dto)
//                navigationController?.pushViewController(contact, animated: true)
//            }
//
//            if let dto = contactDataDTO {
//                pushContact(dto)
//                return
//            }
//
//            let request = GetPageRequest(page: 1)
//            request.per_page = 1
//            request.slug = "lien-he"
//
//            _ = SEPage.getList(request, animation: {
//                self.showLoadingView($0)
//
//            }, completed: { (response) in
//                if !self.checkResponse(response) {
//                    return
//                }
//
//                guard let dto = response.lstPage.first else {
//                    _ = self.showWarningAlert(message: "Unable to find page")
//                    return
//                }
//                self.contactDataDTO = dto
//                pushContact(dto)
//
//            })

        case .address:
            let address = AccountAddressVCtrl()
            navigationController?.pushViewController(address, animated: true)
            
        case .accSetting:
            let setting = AccountSettingVCtrl()
            setting.handleCompleted = configDefaultAccount
            navigationController?.pushViewController(setting, animated: true)
            
        default:
            break
            
        }
    }
    
    func pushAccountShowInfo(_ dto: PageDTO) {
        let store = AccountShowInfo(dto)
        navigationController?.pushViewController(store, animated: true)
    }
    
    func pushMyOrder() {
        guard let id = Order.shared.cusDTO.id else {
            return
        }
        
        let request = GetOrderRequest(page: 1)
        request.customer = id
        
        _ = SEOrder.getList(request, animation: {
            self.view.showLoadingView($0)
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            if response.lstOrder.isEmpty {
                _ = self.showWarningAlert(title: "Thông báo", message: "Bạn chưa tạo đơn hàng nào", buttonTitle: "OK")
                return
            }
            
            response.lstOrder.forEach({ (order) in
                order.line_items.forEach({ (item) in
                    item.productDTO = Base.lstProduct.first(where: { $0.id == item.product_id })
                })
            })
            
            let myOrder = MyOrderVCtrl(response.lstOrder)
            self.navigationController?.pushViewController(myOrder, animated: true)
            
        })
        
    }
    
}

// Handle Sign in - Sign Up
extension AccountVCtrl {
    func btnSignUp_Touched(sender: UIButton) {
        isBack = true
        isSignIn = false
    }
    
    func btnSignUpDetail_Touched(sender: UIButton) {
        isSignIn = false
    }
    
    func btnSignUpConfirm_Touched(sender: UIButton) {
        guard let email = txtSignUpEmail.text?.trim(), email.isEmail else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập đúng định dạng email", buttonTitle: "OK") {
                self.txtSignUpEmail.becomeFirstResponder()
            }
            return
        }

        guard let password = txtSignUpPassword.text, !password.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập mật khẩu", buttonTitle: "OK") {
                self.txtSignUpPassword.becomeFirstResponder()
            }
            return
        }

        guard let confirmPassword = txtSignUpConfirmPassword.text, !confirmPassword.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập xác nhận mật khẩu", buttonTitle: "OK") {
                self.txtSignUpConfirmPassword.becomeFirstResponder()
            }
            return
        }

        if password != confirmPassword {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập xác nhận mật khẩu giống mật khẩu", buttonTitle: "OK")
            return

        }

        let billing = AddressDTO()
        billing.email = email
        
        let request = CustomerDTO()
        request.email = email
        request.password = password
        request.billing = billing
        request.role = ECustomerRole.customer.rawValue

        task = SECustomer.createOrUpdate(request, animation: {
            self.view.showLoadingView($0)

        }) { (response) in
            if !self.checkResponse(response) {
                return
            }

            guard let cusDTO = response.lstCustomer.first else {
                _ = self.showWarningAlert(title: "Cảnh báo", message: "Không thể đăng kí thông tin!")
                return
            }
            Order.shared.updateCusDTO(cusDTO, isSaveUserDefault: true)
            _ = self.showWarningAlert(title: "Thông báo", message: "ĐĂNG KÍ THÀNH CÔNG", buttonTitle: "OK") {
                self.configDefaultAccount()
                self.tbvAccount.reloadData()

            }

        }
        
    }
    
    func btnSignIn_Touched(sender: UIButton) {
        isBack = true
        isSignIn = true
        
    }
    
    func btnSignInDetail_Touched(sender: UIButton) {
        isSignIn = true
    }
    
    func btnSignInConfirm_Touched(sender: UIButton) {
        guard let name = txtSignInName.text?.trim(), !name.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập email", buttonTitle: "OK") {
                self.txtSignInName.becomeFirstResponder()
            }
            return
        }

        guard let password = txtSignInPassword.text, !password.isEmpty else {
            _ = self.showWarningAlert(title: "Thông báo", message: "Vui lòng nhập mật khẩu", buttonTitle: "OK") {
                self.txtSignInPassword.becomeFirstResponder()
            }
            return
        }

        if name.isEmail {
            self.getCustomerDTO(name) { (dto) in
                self.getAuthDTO(dto.username, password: password, completed: { (authDTO) in
                    self.loginSuccess(dto)
                })
            }
            return
        }

        self.getAuthDTO(name, password: password) { (authDTO) in
            self.getCustomerDTO(authDTO.user?.email, completed: { (dto) in
                self.loginSuccess(dto)
            })
        }
    }
 
    func loginSuccess(_ cusDTO: CustomerDTO) {
        cusDTO.password = self.txtSignInPassword.text
        Order.shared.updateCusDTO(cusDTO, isSaveUserDefault: self.btnCheck.isSelected)

        _ = self.showWarningAlert(title: "Thông báo", message: "ĐĂNG NHẬP THÀNH CÔNG", buttonTitle: "OK") {
            self.configDefaultAccount()
            self.tbvAccount.reloadData()

        }

    }
    
}

extension AccountVCtrl: HandleKeyboardProtocol, UITextFieldDelegate {
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
        if lstTextFieldSignUp.contains(textField) {
            handleTextFieldNotInputData(lstTextFieldSignUp)
        }
        
        if lstTextFieldSignIn.contains(textField) {
            handleTextFieldNotInputData(lstTextFieldSignIn)
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleKeyboard(register: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleKeyboard(register: false)
        Base.container.setHiddenAnimationMenu(true)
    }
 
    func handleTextFieldNotInputData(_ lstTextField: [UITextField]) {
        if let tf = lstTextField.first(where: { ($0.text ?? "").isEmpty }) {
            tf.becomeFirstResponder()
            
        } else {
            self.view.endEditing(true)
            if lstTextField == self.lstTextFieldSignUp {
                self.btnSignUpConfirm.sendActions(for: .touchUpInside)
                return
            }
            
            if lstTextField == self.lstTextFieldSignIn {
                self.btnSignInConfirm.sendActions(for: .touchUpInside)
                return
            }
            
        }
        
    }

}


enum EAccountMenu: Int {
    case myOrder
    case favorite
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
            
        case .favorite:
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
        if self == .favorite {
            return UIImage(named: "icon-favorite-notCheck", in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
        }
        return UIImage(named: "icon-" + String(describing: self), in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
    }
}
