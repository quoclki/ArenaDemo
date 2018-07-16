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

    @IBOutlet var vPayment: UIView!
    @IBOutlet weak var vInfoPayment: UIView!
    @IBOutlet weak var vSignUp: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var txtName: CustomUITextField!
    @IBOutlet weak var txtPhone: CustomUITextField!
    @IBOutlet weak var txtEmail: CustomUITextField!
    @IBOutlet weak var txtAddress: CustomUITextField!
    @IBOutlet weak var txvNote: UITextView!
    
    @IBOutlet var vPaymentFooter: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var vMethod: UIView!
    
    // MARK: - Private properties
    
    // MARK: - Properties
    private var order: OrderDTO!
    private var lstItem: [OrderLineItemDTO] {
        return order.line_items
    }
    
    // MARK: - Properties
    
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
        updateLayoutUI()
        
    }

    func updateLayoutUI() {
        if Order.shared.cusDTO.id != nil {
            Order.shared.setUpCustomer()
            vSignUp.isHidden = true
            vInfoPayment.originY = 0
        }
        
        vPayment.height = vInfoPayment.frame.maxY + padding
        tbvOrder.tableHeaderView = vPayment
        tbvOrder.backgroundColor = UIColor(hexString: "F1F2F2")
        
    }

    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(title: "THANH TOÁN")
        vSetSafeArea = vSafe
        addViewToLeftBarItem(createBackButton())
        configTableView()

        mappingUI()
        
    }
    
    func mappingUI() {
        txtName.text = [order.billing?.first_name ?? "", order.billing?.last_name ?? ""].filter({ !$0.isEmpty }).joined(separator: " ")
        txtPhone.text = order.billing?.phone
        txtEmail.text = order.billing?.email
        txtAddress.text = order.billing?.address_1
        [txtName, txtPhone, txtEmail, txtAddress].forEach({
            $0?.delegate = self
        })
        
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()

    }
    
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}

extension PaymentVCtrl: UITableViewDataSource, UITableViewDelegate {
    private var cellID: String {
        return "clvPaymentOrderCellID"
    }
    
    private var paymentCellID: String {
        return "clvPaymentPaymentCellID"
    }
    
    private var headerCellID: String {
        return "clvPaymentHeaderCellID"
    }
    
    private var padding: CGFloat {
        return 15
    }
    
    func configTableView() {
        tbvOrder.backgroundColor = .white
        tbvOrder.register(UINib(nibName: String(describing: TbvOrderCell.self), bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: cellID)
        tbvOrder.register(UINib(nibName: String(describing: TbvOrderPaymentCell.self), bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: paymentCellID)
        tbvOrder.dataSource = self
        tbvOrder.delegate = self
        tbvOrder.separatorStyle = .none
    
        let v = UIView()
        v.frame.size = CGSize(Ratio.width, padding)
        v.backgroundColor = .white
        tbvOrder.tableFooterView = v

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstItem.isEmpty ? 0 : lstItem.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == lstItem.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentCellID) as! TbvOrderPaymentCell
            cell.vBorder.originY = padding
            cell.updateCell()
            return cell
        }
        
        let item = lstItem[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TbvOrderCell
        cell.vBorder.originY = padding
        cell.updateCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == lstItem.count {
            return 118
        }
        let item = lstItem[indexPath.row]
        return max(item.cellHeight, 167)

    }

    func handleDelete(_ tableView: UITableView, indexPath: IndexPath) {
        _ = showAlert(title: "Cảnh báo", message: "Bạn có chắc chắn muốn xoá món hàng này?", leftBtnTitle: "Không", rightBtnTitle: "Có", rightBtnStyle: .destructive, rightAction: {
            self.order.line_items.remove(at: indexPath.row)
            tableView.reloadData()
            
        })
        
    }
    
}

extension PaymentVCtrl: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}

extension PaymentVCtrl: HandleKeyboardProtocol {
    func handleKeyboard(willShow notify: NSNotification) {

    }
    
    func handleKeyboard(willHide notify: NSNotification) {
        
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




