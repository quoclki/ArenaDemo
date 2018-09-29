//
//  AccountFavoriteVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 9/29/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class AccountFavoriteVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    
    // MARK: - Private properties
    private var lstProduct: [ProductDTO] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ lstProduct: [ProductDTO]) {
        super.init()
        self.lstProduct = lstProduct
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: "DANH SÁCH ƯA THÍCH")
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
