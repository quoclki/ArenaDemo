//
//  AccountVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/6/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit

class AccountVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var vLogo: UIView!
    @IBOutlet weak var imvLogo: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tbvAccount: UITableView!
    
    // MARK: - Private properties
    private var lstItem: [EAccountMenu] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        vLogo.height = vLogo.width
        vLogo.cornerRadius = vLogo.width / 2
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(title: "TÀI KHOẢN")
        vSetSafeArea = vSafe
        setupUIForAccount()
        configTableView()
    }
    
    func setupUIForAccount() {
        ImageStore.shared.setImg(toImageView: imvLogo, imgURL: Order.shared.cusDTO?.avatar_url, defaultImg: Base.logo)
        imvLogo.contentMode = .scaleAspectFill
        
        if let cusDTO = Order.shared.cusDTO {
            lstItem = [.myOrder, .favourite, .address, .storeSystem, .orderCondition, .accSetting]
            lblName.text = [cusDTO.first_name ?? "", cusDTO.last_name ?? ""].joined(separator: " ")
        } else {
            lstItem = [.myOrder, .favourite, .orderCondition, .storeSystem, .contactInfo, .signInSignUp]
            lblName.text = "APP BÁN HÀNG"
        }
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

extension AccountVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    private var cellID: String {
        return "tbvAccountCellID"
    }
    
    func configTableView() {
        tbvAccount.register(UINib(nibName: String(describing: TbvAccountCell.self), bundle: Bundle(for: Base.self)), forCellReuseIdentifier: cellID)
        tbvAccount.dataSource = self
        tbvAccount.delegate = self
        tbvAccount.isScrollEnabled = false
        tbvAccount.separatorInset.left = 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvAccountCell
        let item = lstItem[indexPath.row]
        cell.updateCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / CGFloat(lstItem.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

// Handle Sign in - Sign Up
extension AccountVCtrl {
    func btnSignIn_Touched(sender: UIButton) {
        
    }
    
    func btnSignUp_Touched(sender: UIButton) {
        
    }
    
}

enum EAccountMenu: Int {
    case myOrder
    case favourite
    case address
    case storeSystem
    case orderCondition
    case accSetting
    case contactInfo
    case signInSignUp
    
    var name: String {
        switch self {
        case .myOrder:
            return "Đơn Hàng Của Tôi"
            
        case .favourite:
            return "Danh Sách Ưa Thích"
            
        case .address:
            return "Địa Chỉ"
            
        case .storeSystem:
            return "Hệ Thống Cửa Hàng"
            
        case .orderCondition:
            return "Chính Sách Mua Hàng"
            
        case .accSetting:
            return "Cài Đặt Tài Khoản"
            
        case .contactInfo:
            return "Thông Tin Liên Hệ"
            
        default:
            return ""
        }
    }
    
    var icon: UIImage {
        return UIImage(named: "icon-" + String(describing: self), in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
    }
}
