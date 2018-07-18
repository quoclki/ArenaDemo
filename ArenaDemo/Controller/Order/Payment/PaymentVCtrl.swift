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
    
    @IBOutlet var vSignUp: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet var vPaymentFooter: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var vMethod: UIView!
    
    // MARK: - Private properties
    private var lstItem: [EPaymentHeaderType] = []
    private var lstPayemnt: [PaymentMethodDTO] = []
    
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
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(title: "THANH TOÁN")
        vSetSafeArea = vSafe
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
        
        if Order.shared.cusDTO.id == nil {
            tbvOrder.tableHeaderView = vSignUp
            return
        }
        
        Order.shared.setUpCustomer()
        
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnOrder.touchUpInside(block: btnOrder_Touched)
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
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}

extension PaymentVCtrl: UITableViewDataSource, UITableViewDelegate {
    private var paymentInfoCellID: String {
        return "clvPaymentInfoCellID"
    }
    
    private var cellID: String {
        return "clvPaymentOrderCellID"
    }
    
    private var paymentCellID: String {
        return "clvPaymentPaymentCellID"
    }
    
    private var paymentMethodCellID: String {
        return "clvPaymentHeaderCellID"
    }
    
    private var padding: CGFloat {
        return 15
    }
    
    func configTableView() {
        lstItem = [.paymentInfo, .myOrder, .paymentMethod]
        tbvOrder.register(UINib(nibName: String(describing: TbvOrderCell.self), bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: cellID)
        tbvOrder.register(UINib(nibName: String(describing: TbvOrderPaymentCell.self), bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: paymentCellID)
        tbvOrder.register(UINib(nibName: String(describing: TbvPaymentInfoCell.self), bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: paymentInfoCellID)
        tbvOrder.register(UINib(nibName: String(describing: TbvPaymentMethodCell.self), bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: paymentMethodCellID)
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
        vHeader.frame = CGRect(0, 0, tableView.width, 40)
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
        return 40
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
            cell.updateCell(order.billing ?? AddressDTO())
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
            self.order.line_items.remove(at: indexPath.row)
            tableView.reloadData()
            
            if self.lstItemOrder.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }
            
        })
        
    }
        
}

extension PaymentVCtrl: HandleKeyboardProtocol {
    func handleKeyboard(willShow notify: NSNotification) {
        self.handleKeyboard(willShow: notify, scv: tbvOrder)
    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        tbvOrder.setContentOffset(CGPoint(0, self.yOffset), animated: true)
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

