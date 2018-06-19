//
//  AccountVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/19/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class AccountVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var tbvAccount: UITableView!
    
    // MARK: - Private properties
    private var cellID = "tbvAccountCellID"
    private var lstAccount: [CustomerDTO] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ lstAccount: [CustomerDTO]) {
        super.init()
        self.lstAccount = lstAccount
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        configTableView()
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    func configTableView() {
        tbvAccount.register(UINib(nibName: String(describing: TbvAccountCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvAccount.dataSource = self
        tbvAccount.delegate = self
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

extension AccountVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvAccountCell
        let item = lstAccount[indexPath.row]
        cell.updateCell(item)
        
        return cell
    }
    
    
    
}
