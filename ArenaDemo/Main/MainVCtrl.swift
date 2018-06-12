//
//  MainVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/12/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class MainVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var vSlide: UIView!
    @IBOutlet weak var tbvSlideSource: UITableView!
    
    // MARK: - Private properties
    private var cellID: String = "slideCellID"
    private var lstMenu: [MenuData] = []
    
    private var isShowMenu: Bool = false {
        didSet {
            let width = self.view.width
            UIView.animate(withDuration: 0.3) {
                self.vSlide.originX = self.isShowMenu ? width - self.vSlide.width : width
            }
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        navigationController?.navigationBar.isTranslucent = false
        addViewToRightBarItem(view: btnMenu)
        configTableView()
        addSlideView()
    }
    
    func addSlideView() {
        vSlide.frame.origin.x = self.view.width
        self.view.addSubview(vSlide)
        isShowMenu = false
    }
    
    func configTableView() {
        initSlideSource()
        tbvSlideSource.register(UINib(nibName: String(describing: TbvMenuCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvSlideSource.dataSource = self
        tbvSlideSource.delegate = self
        
    }
        
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnMenu.touchUpInside(block: btnMenu_Touched)
    }
    
    // MARK: - Event Handler
    func btnMenu_Touched(sender: UIButton) {
        isShowMenu = !isShowMenu
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    func initSlideSource() {
        var item = MenuData()
        item.menu = .product
        lstMenu.append(item)

        item = MenuData()
        item.menu = .post
        lstMenu.append(item)

    }
}

extension MainVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvMenuCell
        let item = lstMenu[indexPath.row]
        cell.updateCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = lstMenu[indexPath.row]
        navigationController?.popToRootViewController(animated: true)
        isShowMenu = false
        
        switch item.menu {
        case .post:
            pushPost()
            
        case .product:
            pushProductCategoru()
        }
        
    }
    
    func pushPost() {
        let post = PostVCtrl()
        navigationController?.pushViewController(post, animated: true)

    }
    
    func pushProductCategoru() {
        let request = GetCategoryRequest(page: 1)
        
        SEProduct.getListCategory(request, animation: {
            self.showLoadingView($0)
            
        }) { (reponse) in
            if let lst = reponse?.lstCategory {
                let categoryProduct = CategoryVCtrl(lst)
                self.navigationController?.pushViewController(categoryProduct, animated: true)
            }
        }
    }
}

class MenuData {
    var menu: EMenu = .post
    
}

enum EMenu: Int {
    case post
    case product
    
    var title: String {
        switch self {
        case .post:
            return "Post"
            
        case .product:
            return "Product"
            
        }
    }
    
}


