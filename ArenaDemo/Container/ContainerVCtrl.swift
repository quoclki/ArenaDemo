//
//  ContainerVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/24/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class ContainerVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var btnHidden: UIButton!
    @IBOutlet weak var vSlide: UIView!
    @IBOutlet weak var tbvSlide: UITableView!
    
    // MARK: - Private properties
    private var nav: UINavigationController!
    
    // MARK: - Properties
    var isShowMenu: Bool = false {
        didSet {
            let width = self.view.width
            if isShowMenu {
                btnHidden.isHidden = false
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.vSlide.originX = self.isShowMenu ? width - self.vSlide.width : width
                self.btnHidden.alpha = self.isShowMenu ? 0.8 : 0

            }) { (fn) in
                if !self.isShowMenu {
                    self.btnHidden.isHidden = true
                }
            }
        }
    }
    private var cellID: String = "slideCellID"
    private var lstMenu: [MenuData] = []

    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        let main = MainVCtrl()
        nav = UINavigationController(rootViewController: main)
        nav.view.frame.size = self.vMain.frame.size
        addChildViewController(nav)
        self.vMain.addSubview(nav.view)
        
        addRightView()
        configTableView()
        
    }
    
    func addRightView() {
        self.view.addSubview(vSlide)
        vSlide.originX = self.view.width
        btnHidden.isHidden = true
        isShowMenu = false
    }

    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnHidden.touchUpInside(block: btnHidden_Touched)
    }
    
    // MARK: - Event Handler
    func btnHidden_Touched(sender: UIButton) {
        isShowMenu = !isShowMenu
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
//        getMedia()
    }

    func getMedia() {
        let request = GetMediaRequest(page: 1)
        
        _ = SEMedia.getList(request, completed: { (response) in
            
            
        })
        
    }
}
extension ContainerVCtrl: UITableViewDataSource, UITableViewDelegate {
    func configTableView() {
        initSlideSource()
        tbvSlide.register(UINib(nibName: String(describing: TbvMenuCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvSlide.dataSource = self
        tbvSlide.delegate = self
        
    }
    
    func initSlideSource() {
        
        var item = MenuData()
        item.menu = .post
        lstMenu.append(item)
        
        item = MenuData()
        item.menu = .account
        lstMenu.append(item)
        
    }


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
        case .account:
            pushAccount()
        }
        
    }
    
    func pushPost() {
        let request = GetPostCategoryRequest(page: 1)
        
        _ = SEPost.getListCategory(request, animation: {
            self.showLoadingView($0)
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            var lst = response.lstPostCategory
            let all = PostCategoryDTO()
            all.name = "All"
            lst.insert(all, at: 0)
            
            let post = PostVCtrl(lst)
            self.nav.pushViewController(post, animated: true)
            
        }
        
    }
    
    
    func pushAccount() {
        let request = GetCustomerRequest(page: 1)
        request.role = ECustomerRole.all.rawValue
        
        _ = SECustomer.getList(request, animation: {
            self.showLoadingView($0)
            
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            let lst = response.lstCustomer
            let account = AccountVCtrl(lst)
            self.nav.pushViewController(account, animated: true)
            
        }
        
    }
}

class MenuData {
    var menu: EMenu = .post
    
}

enum EMenu: Int {
    case post
    case account
    
    var title: String {
        switch self {
        case .post:
            return "Post"
            
        case .account:
            return "Account"
            
        }
    }
    
}
