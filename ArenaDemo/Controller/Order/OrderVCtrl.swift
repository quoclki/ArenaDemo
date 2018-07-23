//
//  OrderVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/9/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class OrderVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var tbvOrder: UITableView!
    @IBOutlet weak var btnPayment: UIButton!
    
    // MARK: - Private properties
    private var order: OrderDTO!
    private var lstItem: [OrderLineItemDTO] {
        return order.line_items
    }
    
    // MARK: - Properties
    var isCreateBack: Bool = false
    
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
        createNavigationBar(vSafe, title: "GIỎ HÀNG CỦA TÔI (\( order.totalItem.toString() ))")
        configTableView()
        if isCreateBack {
            addViewToLeftBarItem(createBackButton())
        }
        
    }
    
    func addContinueVCtrl() {
        if lstItem.isEmpty {
            let _continue = ContinueOrderVCtrl(true)
            _continue.view.frame.size = view.size
            addChildViewController(_continue)
            view.addSubview(_continue.view)
        }
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        addContinueVCtrl()

    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnPayment.touchUpInside(block: btnPayment_Touched)
    }
    
    // MARK: - Event Handler
    func btnPayment_Touched(sender: UIButton) {
        let payment = PaymentVCtrl(order)
        navigationController?.pushViewController(payment, animated: true)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}

extension OrderVCtrl: UITableViewDataSource, UITableViewDelegate {
    private var cellID: String {
        return "clvOrderCellID"
    }
    
    private var paymentCellID: String {
        return "clvOrderPaymentCellID"
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
        tbvOrder.allowsSelection = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstItem.isEmpty ? 0 : lstItem.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == lstItem.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentCellID) as! TbvOrderPaymentCell
            cell.updateCell()
            cell.clipsToBounds = true
            return cell
        }
        
        let item = lstItem[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TbvOrderCell
        cell.updateCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == lstItem.count {
            return 132
        }
        let item = lstItem[indexPath.row]
        return max(item.cellHeight, 167)
        
    }

    func handleDelete(_ tableView: UITableView, indexPath: IndexPath) {
        _ = showAlert(title: "Cảnh báo", message: "Bạn có chắc chắn muốn xoá món hàng này?", leftBtnTitle: "Không", rightBtnTitle: "Có", rightBtnStyle: .destructive, rightAction: {
            self.order.line_items.remove(at: indexPath.row)
            tableView.reloadData()
            self.addContinueVCtrl()
        })
        
    }
    
}

extension OrderVCtrl: HandleKeyboardProtocol {
    func handleKeyboard(willShow notify: NSNotification) {
        self.handleKeyboard(willShow: notify, scv: self.tbvOrder)
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


