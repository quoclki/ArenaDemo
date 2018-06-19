//
//  MainVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/12/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import WebKit

class MainVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var vSlide: UIView!
    @IBOutlet weak var tbvSlideSource: UITableView!
    
    // MARK: - Private properties
    private var wkWebView: WKWebView!
    private var progressView: UIProgressView!
    
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
        initWKWebview()
//        loadWebView()
        addViewToRightBarItem(view: btnMenu)
        addViewToLeftBarItem(view: btnBack)
        configTableView()
        addSlideView()
    }
    
    func initWKWebview() {
        wkWebView = WKWebView(frame: self.view.bounds)
        wkWebView.navigationDelegate = self
        self.view.addSubview(wkWebView)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        wkWebView.addSubview(progressView)
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(wkWebView.estimatedProgress)
        }
    }

    
    func loadWebView() {
        let urlString = "http://xhome.com.vn"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }

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
        wkWebView.frame = self.view.bounds
        progressView.frame.size.width = wkWebView.width
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnMenu.touchUpInside(block: btnMenu_Touched)
        btnBack.touchUpInside(block: btnBack_Touched)
    }
    
    // MARK: - Event Handler
    func btnMenu_Touched(sender: UIButton) {
        isShowMenu = !isShowMenu
    }
    
    func btnBack_Touched(sender: UIButton) {
        wkWebView.goBack()
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

        item = MenuData()
        item.menu = .account
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
        case .account:
            pushAccount()
        }
        
    }
    
    func pushPost() {
        let request = GetPostCategoryRequest(page: 1)
        
        SEPost.getListCategory(request, animation: {
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
            self.navigationController?.pushViewController(post, animated: true)
            
        }
        
    }
    
    func pushProductCategoru() {
        let request = GetCategoryRequest(page: 1)
        
        SEProduct.getListCategory(request, animation: {
            self.showLoadingView($0)
            
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }

            var lst = response.lstCategory
            lst.insert(self.getAllCategory(), at: 0)
            let categoryProduct = CategoryVCtrl(lst)
            self.navigationController?.pushViewController(categoryProduct, animated: true)
            
        }
    }
    
    func pushAccount() {
        let request = GetCustomerRequest(page: 1)
        request.role = ECustomerRole.all.rawValue
        
        SECustomer.getList(request, animation: {
            self.showLoadingView($0)
            
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            let lst = response.lstCustomer
            let account = AccountVCtrl(lst)
            self.navigationController?.pushViewController(account, animated: true)
            
        }

    }
}

extension MainVCtrl: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        progressView.isHidden = true
    }
    
    
}

class MenuData {
    var menu: EMenu = .post
    
}

enum EMenu: Int {
    case post
    case product
    case account
    
    var title: String {
        switch self {
        case .post:
            return "Post"
            
        case .product:
            return "Product"
         
        case .account:
            return "Account"
            
        }
    }
    
}


