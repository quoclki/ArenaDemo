//
//  PaymentVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class PaymentVCtrl: BaseVCtrl {

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
    
    @IBOutlet weak var btnPaymentMethod: UIButton!
    @IBOutlet weak var lblPaymentMethodDescription: UILabel!
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    // MARK: - Private properties
    private var cellID = "tbvPaymentOrderCellID"
    private var order: OrderDTO {
        return Order.shared.orderDTO
    }
    private var lstItem: [PaymentOrderData] = []

    // MARK: - Properties
    private var lstPayment: [PaymentMethodDTO] = []
    private var paymentMethodID: String? = nil {
        didSet {
            guard let method = lstPayment.first(where: { $0.id == paymentMethodID }) else { return }
            btnPaymentMethod.setTitle(method.title, for: .normal)
            lblPaymentMethodDescription.text = method.description

        }
    }
    
    // MARK: - Init
    init(_ lstPayment: [PaymentMethodDTO]) {
        super.init()
        self.lstPayment = lstPayment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Payment"
        vPayment.width = scv.width
        vPayment.height = vPayment.frame.maxY
        scv.addSubview(vPayment)
        scv.contentSize.height = vPayment.height
        configTableView()
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnPaymentMethod.touchUpInside(block: btnPaymentMethod_Touched)
        
    }
    
    // MARK: - Event Handler
    func btnPaymentMethod_Touched(sender: UIButton) {
        let roleMenu = UIAlertController(title: "Choose Payment", message: nil, preferredStyle: .actionSheet)
        lstPayment.forEach { (payment) in
            let action = UIAlertAction(title: payment.title, style: .default) { (action) in
                self.paymentMethodID = payment.id
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
        
    }
    
    func btnCancel_Touched(sender: UIButton) {
        
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        loadInfo()
        
    }
    
    func loadInfo() {
        paymentMethodID = lstPayment.first?.id
        txtFirstName.text = order.billing?.first_name
        txtLastName.text = order.billing?.last_name
        txtCountry.text = order.billing?.country
        txtAddress.text = order.billing?.address_1
        txtCity.text = order.billing?.city
        txtPhone.text = order.billing?.phone
        txtEmail.text = order.billing?.email
    }

}

extension PaymentVCtrl: UITableViewDataSource, UITableViewDelegate {
    func configTableView() {
        tbvOrderInfo.register(UINib(nibName: String(describing: TbvPaymentOrderInfoCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvOrderInfo.dataSource = self
        tbvOrderInfo.delegate = self
        tbvOrderInfo.isScrollEnabled = false
        genSource()
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
        total.value = Order.shared.subTotal.toString()
        lstItem.append(total)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lstItem.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstItem[section].lstItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvPaymentOrderInfoCell
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





