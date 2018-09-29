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
    @IBOutlet weak var tbvFavorite: UITableView!
    @IBOutlet var vRight: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblTotalOrder: UILabel!

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
        addViewToRightBarItem(vRight)
        configTableView()
        lblTotalOrder.cornerRadius = lblTotalOrder.height / 2

    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        updateCart()
    }
    
    func updateCart() {
        let totalItem = Order.shared.orderDTO.totalItem
        lblTotalOrder.text = totalItem.toString()
        lblTotalOrder.isHidden = totalItem == 0
        tbvFavorite.reloadData()
    }

    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnCart.touchUpInside(block: btnCart_Touched)
    }
    
    // MARK: - Event Handler
    func btnCart_Touched(sender: UIButton) {
        pushMyOrderVCtrl(true)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }

}

extension AccountFavoriteVCtrl: UITableViewDataSource, UITableViewDelegate {
    private var cellID: String {
        return String(describing: TbvFavoriteCell.self)
    }
    
    private var padding: CGFloat {
        return 15
    }
    
    func configTableView() {
        tbvFavorite.backgroundColor = .white
        tbvFavorite.register(UINib(nibName: cellID, bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: cellID)
        tbvFavorite.dataSource = self
        tbvFavorite.delegate = self
        tbvFavorite.separatorStyle = .none
        tbvFavorite.allowsSelection = false
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = lstProduct[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TbvFavoriteCell
        cell.updateCell(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == lstProduct.count - 1 ? 0 : 15
    }
    
    func handleDelete(_ tableView: UITableView, indexPath: IndexPath) {
        _ = showAlert(title: "Cảnh báo", message: "Bạn có chắc chắn muốn xoá món hàng này?", leftBtnTitle: "Không", rightBtnTitle: "Có", rightBtnStyle: .destructive, rightAction: {
            self.lstProduct.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            FavoriteData.shared.handleFavoriteList(self.lstProduct[indexPath.row].id, isSave: false)
            if self.lstProduct.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
    }
    
}

