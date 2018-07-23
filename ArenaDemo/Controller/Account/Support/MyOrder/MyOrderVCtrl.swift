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
