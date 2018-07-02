//
//  ContainerVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/2/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit

class ContainerVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vBar: UIView!
    @IBOutlet weak var vBody: UIView!
    @IBOutlet weak var vMenu: UIView!
    
    // MARK: - Private properties
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        configMenu()
    }
    
    func configMenu() {
        if let statusbar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusbar.backgroundColor = Base.baseColor
        }

        let lstMenu = [EMenu.home, .category, .order, .account]
        let width = self.vMenu.width / CGFloat(lstMenu.count)
        for (index, element) in lstMenu.enumerated() {
            let v = UIView()
            v.frame = CGRect(width * CGFloat(index), 0, width, self.vMenu.height)
            v.clipsToBounds = true
            
            let btn = UIButton(type: .system)
            btn.frame.size = v.frame.size
            btn.frame.origin = CGPoint.zero
            btn.setTitle(element.name, for: .normal)
            v.addSubview(btn)
            
            vMenu.addSubview(v)

        }
        
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

enum EMenu: Int {
    case home
    case category
    case order
    case account
    
    var name: String {
        switch self {
        case .home:
            return "Trang chủ"
            
        case .category:
            return "Danh mục"
            
        case .order:
            return "Giỏ"
            
        case .account:
            return "Tài khoản"
        }
    }
}
