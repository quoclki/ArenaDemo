//
//  MyOrderVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/22/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class MyOrderVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var tbvMyOrder: UITableView!
    
    // MARK: - Private properties
    private var lstOrder: [OrderDTO] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ lstOrder: [OrderDTO]) {
        super.init()
        self.lstOrder = lstOrder
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: "ĐƠN HÀNG CỦA TÔI")
        addViewToLeftBarItem(createBackButton())
        configTableView()
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
        setupItemLine()
    }
    
    func setupItemLine() {
        let lstItem = self.lstOrder.flatMap({ $0.line_items }).filter({ $0.productDTO == nil })
        if lstItem.isEmpty {
            return
        }
        
        var lstID: Set<Int> = []
        lstItem.forEach{
            lstID.insert($0.product_id ?? 0)
        }
        
        let request = GetProductRequest(page: 1)
        request.include = lstID.map({ $0 })
        
        _ = SEProduct.getListProduct(request, animation: { isShow in
            
        }, completed: { (response) in
            guard let visibleCell = self.tbvMyOrder.visibleCells as? [TbvMyOrderCell] else {
                return
            }
            
            var lstIndexPath: [IndexPath] = []
            visibleCell.forEach({ (cell) in
                if cell.item.productDTO == nil {
                    if let indexPath = self.tbvMyOrder.indexPath(for: cell) {
                        lstIndexPath.append(indexPath)
                    }
                    cell.item.productDTO = response.lstProduct.first(where: { $0.id == cell.item?.product_id })
                }
            })
            if !lstIndexPath.isEmpty {
                self.tbvMyOrder.reloadRows(at: lstIndexPath, with: .automatic)
            }
            
            lstItem.forEach({ (item) in
                item.productDTO = response.lstProduct.first(where: { $0.id == item.product_id })
            })
            
        })

    }
}

extension MyOrderVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    private var headerCellID: String {
        return String(describing: TbvMyOrderHeaderCell.self)
    }
    
    private var cellID: String {
        return String(describing: TbvMyOrderCell.self)
    }
    
    func configTableView() {
        tbvMyOrder.register(UINib(nibName: headerCellID, bundle: Bundle(for: Base.self)), forCellReuseIdentifier: headerCellID)
        tbvMyOrder.register(UINib(nibName: cellID, bundle: Bundle(for: Base.self)), forCellReuseIdentifier: cellID)
        tbvMyOrder.dataSource = self
        tbvMyOrder.delegate = self
        tbvMyOrder.separatorInset.left = 15
        tbvMyOrder.separatorInset.right = 15
        tbvMyOrder.allowsSelection = false
        tbvMyOrder.backgroundColor = UIColor(hexString: "F1F2F2")
        tbvMyOrder.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lstOrder.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vHeader = tableView.dequeueReusableCell(withIdentifier: headerCellID) as? TbvMyOrderHeaderCell
        vHeader?.updateCell(lstOrder[section])
        return vHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == lstOrder.count - 1 ? 0 : 10
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstOrder[section].line_items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvMyOrderCell
        let item = lstOrder[indexPath.section].line_items[indexPath.row]
        cell.updateCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

}

