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
    @IBOutlet weak var vBody: UIView!
    @IBOutlet weak var vMenu: UIView!
    
    // MARK: - Private properties
    private var tab: EMenu! {
        didSet {
            selectedTab()
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        configNavigation()
        configMenu()
    }
    
    func configMenu() {
        let lstMenu = [EMenu.home, .category, .order, .account]
        let width = Ratio.width / CGFloat(lstMenu.count)
        for (index, element) in lstMenu.enumerated() {
            let v = UIView()
            v.frame = CGRect(width * CGFloat(index), 0, width, self.vMenu.height)
            v.tag = index
            v.clipsToBounds = true
            
            let btn = UIButton(type: .system)
            btn.frame.size = v.frame.size
            btn.frame.origin = CGPoint.zero
            btn.tag = v.tag
            btn.touchUpInside(block: btnMenu_Touched)
            v.addSubview(btn)

            let imv = UIImageView()
            imv.frame.size = CGSize(20, 20)
            imv.image = element.icon
            imv.originY = 7
            imv.center.x = btn.center.x
            v.addSubview(imv)
            
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
            label.text = element.name
            label.sizeToFit()
            label.originY = imv.frame.maxY + 3
            label.center.x = btn.center.x
            v.addSubview(label)
            
            vMenu.addSubview(v)
        }
        
        self.tab = .home
        
    }
    
    func configNavigation() {
        if let statusbar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusbar.backgroundColor = Base.baseColor
        }
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = true
        navBar.isExclusiveTouch = false

    }
    

    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        
    }
    
    // MARK: - Event Handler
    func btnMenu_Touched(sender: UIButton) {
        guard let tab = EMenu(rawValue: sender.tag) else { return }
        if self.tab == tab {
            return
        }
        
        self.tab = tab
        
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    func selectedTab() {
        vBody.cleanSubViews()
        let vctrl = tab.controller
        vctrl.view.size = vBody.size
        addChildViewController(vctrl)
        vBody.addSubview(vctrl.view)
        
        let selectedColor = UIColor(hexString: "ED1C24")
        let unSelectedColor = UIColor(hexString: "A5A5A5")
        for v in vMenu.subviews {
            guard let imv = v.subviews.first(where: { $0 is UIImageView }) as? UIImageView else {
                continue
            }
            
            guard let label = v.subviews.first(where: { $0 is UILabel }) as? UILabel else {
                return
            }
            
            if v.tag == tab.rawValue {
                imv.setTintColor(selectedColor)
                label.textColor = selectedColor
                continue
            }
            
            imv.setTintColor(unSelectedColor)
            label.textColor = unSelectedColor

        }
        
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
    
    var controller: BaseVCtrl {
        switch self {
        case .home:
            return MainVCtrl()
            
        case .category:
            return CategoryVCtrl()
            
        default:
            return MainVCtrl()
        }
    }
    
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(named: "icon-home", in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
        case .category:
            return UIImage(named: "icon-category", in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
        case .order:
            return UIImage(named: "icon-order", in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
        case .account:
            return UIImage(named: "icon-acc", in: Bundle(for: Base.self), compatibleWith: nil) ?? UIImage()
        }
    }
}
