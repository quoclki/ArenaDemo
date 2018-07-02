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
    @IBOutlet var btnAdd: UIButton!
    
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
        addViewToRightBarItem(view: btnAdd)
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
        btnAdd.touchUpInside(block: btnAdd_Touched)
    }
    
    // MARK: - Event Handler
    func btnAdd_Touched(sender: UIButton) {
        let detail = AccountDetailVCtrl()
        detail.completed = handleCompletedEdit
        navigationController?.pushViewController(detail, animated: true)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    func handleCompletedEdit(customDTO: CustomerDTO) {
        if let index = lstAccount.index(where: { $0.id == customDTO.id }) {
            lstAccount[index] = customDTO
        } else {
            lstAccount.append(customDTO)
        }
        
        tbvAccount.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = lstAccount[indexPath.row]
        let detail = AccountDetailVCtrl(item)
        detail.completed = handleCompletedEdit
        navigationController?.pushViewController(detail, animated: true)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = lstAccount[indexPath.row]
            let request = DeleteCustomerRequest()
            request.id = item.id
            request.force = "true"
            
            _ = SECustomer.delete(request, animation: {
                self.showLoadingView($0)
            }) { (response) in
                if !self.checkResponse(response) {
                    return
                }

                self.lstAccount.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
            
        }
    }
}
