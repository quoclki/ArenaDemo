//
//  SummaryVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class SummaryVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var scv: UIScrollView!
    
    @IBOutlet var vPayment: UIView!
    
    @IBOutlet weak var vBilling: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    
    @IBOutlet weak var vOrderInfo: UIView!
    @IBOutlet weak var tbvOrderInfo: UITableView!
    
    @IBOutlet weak var vPaymentInfo: UIView!
    @IBOutlet weak var btnPaymentMethod: UIButton!
    @IBOutlet weak var lblPaymentMethodDescription: UILabel!
    
    @IBOutlet weak var vAction: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    // MARK: - Private properties
    private var headerCellID = "tbvPaymentOrderHeaderCellID"
    private var cellID = "tbvPaymentOrderCellID"
    private var order: OrderDTO!
    private var isSummary: Bool {
        return order.id != nil
    }
    private var lstItem: [PaymentOrderData] = []

    // MARK: - Properties
    private var lstPayment: [PaymentMethodDTO] {
        return Base.lstPayment
    }
    
    private var paymentMethod: PaymentMethodDTO? = nil {
        didSet {
            btnPaymentMethod.setTitle(paymentMethod?.title, for: .normal)
            lblPaymentMethodDescription.text = paymentMethod?.description
        }
    }
    
    // MARK: - Init
    init(_ order: OrderDTO) {
        super.init()
        self.order = order
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Summary"
        scv.addSubview(vPayment)
        configTableView()
        vPayment.width = scv.width
        vOrderInfo.frame.size.height = tbvOrderInfo.frame.maxY
        vPaymentInfo.originY = vOrderInfo.frame.maxY + 10
        vPayment.height = vPaymentInfo.frame.maxY
        scv.contentSize.height = vPayment.height
        
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnPaymentMethod.touchUpInside(block: btnPaymentMethod_Touched)
        btnConfirm.touchUpInside(block: btnConfirm_Touched)
        btnCancel.touchUpInside(block: btnCancel_Touched)
    }
    
    // MARK: - Event Handler
    func btnPaymentMethod_Touched(sender: UIButton) {
        let roleMenu = UIAlertController(title: "Choose Payment", message: nil, preferredStyle: .actionSheet)
        lstPayment.forEach { (payment) in
            let action = UIAlertAction(title: payment.title, style: .default) { (action) in
                self.paymentMethod = payment
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
    
    func btnConfirm_Touched(sender: UIButton) {
        guard let request = OrderDTO.fromJson(order.toJson()) else { return }
        let billing = AddressDTO()
        billing.first_name = txtFirstName.text ?? ""
        billing.last_name = txtLastName.text ?? ""
        billing.address_1 = txtAddress.text ?? ""
        billing.city = txtCity.text ?? ""
        billing.country = txtCountry.text ?? ""
        billing.phone = txtPhone.text ?? ""
        billing.email = txtEmail.text ?? ""
        
        request.payment_method = paymentMethod?.id
        request.payment_method_title = paymentMethod?.description
        request.status = EOrderStatus.processing.rawValue
        request.billing = billing
        request.customer_note = txtNote.text
        
        _ = SEOrder.createOrUpdate(request, animation: {
            self.showLoadingView($0)
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            if response.lstOrder.isEmpty {
                _ = self.showWarningAlert(message: "Cannot create order!")
            }
            
            _ = self.showWarningAlert(message: "Completed to create order!") {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        })
        
        
    }
    
    func btnCancel_Touched(sender: UIButton) {
        Order.shared.clearOrder()
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        loadInfo()
        
    }
    
    func loadInfo() {
        if let paymentID = order.payment_method, !paymentID.isEmpty {
            paymentMethod = lstPayment.first(where: { $0.id == paymentID })
            
        } else {
            paymentMethod = lstPayment.first
        }
        
        txtFirstName.text = order.billing?.first_name
        txtLastName.text = order.billing?.last_name
        txtCountry.text = order.billing?.country
        txtAddress.text = order.billing?.address_1
        txtCity.text = order.billing?.city
        txtPhone.text = order.billing?.phone
        txtEmail.text = order.billing?.email
        btnPaymentMethod.isUserInteractionEnabled = !isSummary
        vBilling.isUserInteractionEnabled = !isSummary
        
        if isSummary {
            vAction.isHidden = true
            scv.frame.size = self.view.size
        }
    }

}

extension SummaryVCtrl: UITableViewDataSource, UITableViewDelegate {
    func configTableView() {
        tbvOrderInfo.register(UINib(nibName: String(describing: TbvSummaryOrderInfoCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvOrderInfo.register(UINib(nibName: String(describing: TbvSummaryOrderInfoCell.self), bundle: nil), forCellReuseIdentifier: headerCellID)
        tbvOrderInfo.dataSource = self
        tbvOrderInfo.delegate = self
        tbvOrderInfo.isScrollEnabled = false
        tbvOrderInfo.tableFooterView = UIView()
        genSource()
        tbvOrderInfo.height = CGFloat(44 * (lstItem.count + lstItem.flatMap({ $0.lstItem }).count))
        
    }
    
    func genSource() {
        lstItem.removeAll()
        // Product
        let product = PaymentOrderData()
        product.name = "Product"
        product.value = "Total"
        product.lstItem = order.line_items
        lstItem.append(product)
        
        // Total
        let total = PaymentOrderData()
        total.name = "Total"
        total.value = Order.shared.total.toStringDecimal(placeMinimum: 0, placeMaximum: 2)
        lstItem.append(total)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lstItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: headerCellID) as? TbvSummaryOrderInfoCell
        let item = lstItem[section]
        header?.updateCellHeader(name: item.name, value: item.value)
        header?.backgroundColor = UIColor(hexString: "DEDEDE", a: 0.5)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstItem[section].lstItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvSummaryOrderInfoCell
        let item = lstItem[indexPath.section].lstItem[indexPath.row]
        cell.updateCell(item)
        return cell
    }
    
    
}

class PaymentOrderData {
    var name: String = ""
    var value: String = ""
    var lstItem: [OrderLineItemDTO] = []
}





