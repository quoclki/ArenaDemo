//
//  OrderVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class OrderVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tbvOrder: UITableView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    // MARK: - Private properties
    private var cellID = "tbvOrderCellID"
    private var lstItem: [OrderLineItemDTO] {
        return Order.shared.orderDTO.line_items
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Order"
        configTableView()
        addViewToLeftBarItem(view: btnBack)
        
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnBack.touchUpInside(block: btnBack_Touched)
    }
    
    func btnBack_Touched(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Event Handler
    func btnConfirm_Touched(sender: UIButton) {
        let orderDetail = Order.shared.orderDTO
        
        func pushPayment() {
            let payment = PaymentVCtrl()
            navigationController?.pushViewController(payment, animated: true)
        }
        
        if orderDetail.customer_id == nil {
            _ = showAlert(title: "Warning", message: "If you have account, please login!", leftBtnTitle: "Yes", leftBtnStyle: .default, leftAction: {
                let login = LoginVCtrl()
                login.completed = { dto in
                    orderDetail.customer_id = dto.id
                    orderDetail.shipping = dto.shipping
                    orderDetail.billing = dto.billing
                    pushPayment()
                }
                
            }, rightBtnTitle: "Continue", rightBtnStyle: .default, rightAction: {
                pushPayment()
            })
            return
        }
        
        pushPayment()
        
    }
    
    func btnCancel_Touched(sender: UIButton) {
        Order.shared.clearOrder()
        btnBack.sendActions(for: .touchUpInside)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        updateTotal()
    }
    
    func updateTotal() {
        lblTotal.text = Order.shared.subTotal.toString()
    }
}

extension OrderVCtrl: UITableViewDataSource, UITableViewDelegate {
    func configTableView() {
        tbvOrder.register(UINib(nibName: String(describing: TbvOrderCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvOrder.dataSource = self
        tbvOrder.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvOrderCell
        let item = lstItem[indexPath.row]
        cell.updateCell(item)
        cell.updateTotal = updateTotal
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = lstItem[indexPath.row]
        guard let quantity = item.quantity else { return }
        item.quantity = quantity + 1
        tbvOrder.reloadRows(at: [indexPath], with: .automatic)
        updateTotal()

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Order.shared.orderDTO.line_items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateTotal()
            
        }
    }


}

