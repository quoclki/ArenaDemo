//
//  PaymentVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/12/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class PaymentVCtrl: BaseVCtrl {
    
    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var tbvOrder: UITableView!
    @IBOutlet weak var btnOrder: UIButton!
    
    @IBOutlet var vSignIn: UIView!
    @IBOutlet weak var vSignInHeader: UIView!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var vSignInDetail: UIView!
    @IBOutlet weak var txtSignInName: CustomUITextField!
    @IBOutlet weak var txtSignInPassword: CustomUITextField!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnCheckRemember: UIButton!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var btnSignUpConfirm: UIButton!

    @IBOutlet var vPaymentFooter: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var vMethod: UIView!
    
    // MARK: - Private properties
    private var lstItem: [EPaymentHeaderType] = []
    private var lstPayemnt: [PaymentMethodDTO] = []
    
    private var isShowHeader: Bool? {
        didSet {
            guard let isShowHeader = isShowHeader else {
                self.tbvOrder.tableHeaderView = nil
                return
            }
            
            if isShowHeader {
                vSignIn.height = vSignInHeader.height
                tbvOrder.tableHeaderView = vSignIn
                return
            }
            vSignIn.height = vSignInDetail.frame.maxY
            tbvOrder.tableHeaderView = vSignIn
            
        }
    }
    
    // MARK: - Properties
    private var lstItemOrder: [OrderLineItemDTO] {
        return order.line_items
    }
    
    // MARK: - Properties
    var order: OrderDTO!
    
    // MARK: - Init
    init(_ order: OrderDTO) {
        super.init()
        self.order = order
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        btnSignUpConfirm.cornerRadius = btnSignUpConfirm.height / 2
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: "THANH TOÁN")
        addViewToLeftBarItem(createBackButton())
        configTableView()
        updateLayoutUI()
    }
    
    func updateLayoutUI() {
        lstPayemnt.removeAll()
        Base.lstPayment.forEach { (method) in
            if let dto = PaymentMethodDTO.fromJson(method.toJson()), dto.enabled == true {
                lstPayemnt.append(dto)
            }
        }
        lstPayemnt.first?.isCheck = true
        order.lstPayment = lstPayemnt
        
        vSignIn.clipsToBounds = true
        if Order.shared.cusDTO.id == nil {
            isShowHeader = true
            return
        }
        
        order.setupCustomer(Order.shared.cusDTO)
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnOrder.touchUpInside(block: btnOrder_Touched)
        btnSignIn.touchUpInside(block: btnSignIn_Touched)
        
        txtSignInName.delegate = self
        txtSignInPassword.delegate = self
        btnCheck.touchUpInside(block: btnCheck_Touched)
        btnCheckRemember.touchUpInside(block: btnCheck_Touched)
        btnSignUpConfirm.touchUpInside(block: btnSignUpConfirm_Touched)

    }
    
    // MARK: - Event Handler
    func btnOrder_Touched(sender: UIButton) {
        guard let paymentSelected = order.lstPayment.first(where: { $0.isCheck }) else {
            return
        }
        
        guard let request = order else {
            return
        }
        
        request.payment_method = paymentSelected.id
        request.payment_method_title = paymentSelected.title
        request.status = EOrderStatus.processing.rawValue

        _ = SEOrder.createOrUpdate(request, animation: {
            self.showLoadingView($0)
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
          
            let complete = ContinueOrderVCtrl(false)
            self.navigationController?.pushViewController(complete, animated: true)
        })
    }
    
    func btnSignIn_Touched(sender: UIButton) {
        guard let isShowHeader = self.isShowHeader else {
            return
        }
        
        self.isShowHeader = !isShowHeader
        
    }
    
    func btnSignUpConfirm_Touched(sender: UIButton) {
        view.endEditing(true)
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

    func btnCheck_Touched(sender: UIButton) {
        btnCheck.isSelected = !btnCheck.isSelected
    }

    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    func loginSuccess(_ cusDTO: CustomerDTO) {
        cusDTO.password = self.txtSignInPassword.text
        Order.shared.updateCusDTO(cusDTO, isSaveUserDefault: self.btnCheck.isSelected)
        order.setupCustomer(Order.shared.cusDTO)
     
        isShowHeader = nil
        guard let index = lstItem.index(where: { $0 == .paymentInfo }) else {
            return
        }
        tbvOrder.reloadSections(IndexSet(integer: index), with: .none)
        
    }

}

extension PaymentVCtrl: UITableViewDataSource, UITableViewDelegate {
    private var paymentInfoCellID: String {
        return String(describing: TbvPaymentInfoCell.self)
    }
    
    private var cellID: String {
        return String(describing: TbvOrderCell.self)
    }
    
    private var paymentCellID: String {
        return String(describing: TbvOrderPaymentCell.self)
    }
    
    private var paymentMethodCellID: String {
        return String(describing: TbvPaymentMethodCell.self)
    }
    
    private var padding: CGFloat {
        return 15
    }
    
    private var headerHeight: CGFloat {
        return 45
    }
    
    func configTableView() {
        lstItem = [.paymentInfo, .myOrder, .paymentMethod]
        tbvOrder.register(UINib(nibName: cellID, bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: cellID)
        tbvOrder.register(UINib(nibName: paymentCellID, bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: paymentCellID)
        tbvOrder.register(UINib(nibName: paymentInfoCellID, bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: paymentInfoCellID)
        tbvOrder.register(UINib(nibName: paymentMethodCellID, bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: paymentMethodCellID)
        tbvOrder.dataSource = self
        tbvOrder.delegate = self
        tbvOrder.separatorStyle = .none
        tbvOrder.backgroundColor = UIColor(hexString: "F1F2F2")
        tbvOrder.allowsSelection = false
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lstItem.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vHeader = UIView()
        vHeader.frame = CGRect(0, 0, tableView.width, headerHeight)
        vHeader.backgroundColor = .white
        vHeader.borderColor = tableView.backgroundColor ?? .white
        vHeader.borderWidth = 1
        
        let label = UILabel()
        label.frame = CGRect(padding, 0, vHeader.width - padding * 2, vHeader.height)
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        label.text = lstItem[section].name
        vHeader.addSubview(label)
        
        return vHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let header = lstItem[section]
        if [.paymentInfo, .paymentMethod].contains(header) {
            return 1
        }
        return lstItemOrder.isEmpty ? 0 : lstItemOrder.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let header = lstItem[indexPath.section]
        
        if header == .paymentInfo {
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentInfoCellID) as! TbvPaymentInfoCell
            cell.updateCell(order)
            return cell
        }
        
        if header == .myOrder {
            if indexPath.row == lstItemOrder.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: paymentCellID) as! TbvOrderPaymentCell
                cell.vBorder.originY = padding
                cell.updateCell()
                return cell
            }
            
            let item = lstItemOrder[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TbvOrderCell
            cell.vBorder.originY = padding
            cell.updateCell(item, isPayment: true)
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: paymentMethodCellID) as! TbvPaymentMethodCell
        cell.updateCell(order)
        cell.backgroundColor = tableView.backgroundColor
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let headerData = lstItem[indexPath.section]
        if headerData == .paymentInfo {
            return 442
        }
        
        if headerData == .myOrder {
            if indexPath.row == lstItemOrder.count {
                return 205
            }
            let item = lstItemOrder[indexPath.row]
            return max(item.cellHeight, 167)
            
        }
        
        return order.payment_method_cellHeight
        
    }
    
    func handleDelete(_ tableView: UITableView, indexPath: IndexPath) {
        _ = showAlert(title: "Cảnh báo", message: "Bạn có chắc chắn muốn xoá món hàng này?", leftBtnTitle: "Không", rightBtnTitle: "Có", rightBtnStyle: .destructive, rightAction: {
            let item = self.order.line_items[indexPath.row]
            self.order.deleteOrderLintItem(item)
            tableView.reloadData()
            
            if self.lstItemOrder.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }
            
        })
        
    }
        
}

extension PaymentVCtrl: HandleKeyboardProtocol, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func handleKeyboard(willShow notify: NSNotification) {
        self.handleKeyboard(willShow: notify, scv: tbvOrder)
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        self.handleKeyboard(willHide: notify, scv: self.tbvOrder)
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

enum EPaymentHeaderType: Int {
    case paymentInfo
    case myOrder
    case paymentMethod
    
    var name: String {
        switch self {
        case .paymentInfo:
            return "THÔNG TIN THANH TOÁN"
            
        case .myOrder:
            return "ĐƠN HÀNG CỦA BẠN"
            
        case .paymentMethod:
            return "PHƯƠNG THỨC THANH TOÁN"
            
        }
    }
}

