//
//  AccountOrderHistoryVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/25/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class AccountOrderHistoryVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var tbvAccountOrder: UITableView!
    
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
        title = "History"
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
        
    }
    
}

extension AccountOrderHistoryVCtrl: UITableViewDataSource, UITableViewDelegate {
    private var cellID: String {
        return "tbvAccountOrderCellID"
    }
    
    func configTableView() {
        tbvAccountOrder.register(UINib(nibName: String(describing: TbvAccountOrderCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvAccountOrder.dataSource = self
        tbvAccountOrder.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvAccountOrderCell
        let item = lstOrder[indexPath.row]
        cell.updateCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = lstOrder[indexPath.row]
        let summary = SummaryVCtrl(item)
        navigationController?.pushViewController(summary, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    
}

