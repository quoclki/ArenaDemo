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
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnConfirm.touchUpInside(block: btnConfirm_Touched)
        btnCancel.touchUpInside(block: btnCancel_Touched)
    }
    
    // MARK: - Event Handler
    func btnConfirm_Touched(sender: UIButton) {
        let orderDetail = Order.shared.orderDTO
        
        func pushPayment() {
            let summary = SummaryVCtrl(Order.shared.orderDTO)
            self.navigationController?.pushViewController(summary, animated: true)
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
                let nav = UINavigationController(rootViewController: login)
                nav.navigationBar.isTranslucent = false
                self.present(nav, animated: true, completion: nil)
                
            }, rightBtnTitle: "Continue", rightBtnStyle: .default, rightAction: {
                pushPayment()
            })
            return
        }
        
        pushPayment()
        
    }
    
    func btnCancel_Touched(sender: UIButton) {
        Order.shared.clearOrder()
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        updateTotal()
    }
    
    func updateTotal() {
        lblTotal.text = Order.shared.total.toString()
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
        item.quantity += 1
        item.calculateSubTotal()
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

