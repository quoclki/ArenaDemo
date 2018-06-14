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
    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var webView: UIWebView!
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
        addViewToLeftBarItem(view: btnBack)
        configTableView()
        addSlideView()
        loadWebView()
    }
    
    func loadWebView() {
        let urlString = "http://xhome.com.vn"
        webView.delegate = self
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            webView.loadRequest(request)
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
        webView.goBack()
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
        let request = GetPostCategoryRequest(page: 1)
        
        SEPost.getListCategory(request, animation: {
            self.showLoadingView($0)
        }) { (response) in
            if var lst = response?.lstPostCategory {
                let all = PostCategoryDTO()
                all.name = "All"
                lst.insert(all, at: 0)

                let post = PostVCtrl(lst)
                self.navigationController?.pushViewController(post, animated: true)

            }
        }
    }
    
    func pushProductCategoru() {
        let request = GetCategoryRequest(page: 1)
        
        SEProduct.getListCategory(request, animation: {
            self.showLoadingView($0)
            
        }) { (reponse) in
            if var lst = reponse?.lstCategory {
                lst.insert(self.getAllCategory(), at: 0)
                let categoryProduct = CategoryVCtrl(lst)
                self.navigationController?.pushViewController(categoryProduct, animated: true)
            }
        }
    }
}

extension MainVCtrl: UIWebViewDelegate {
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        print(#function)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        print(#function)
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(#function)
        print(error)
//        startLoadingAnimation(isStart: false)
//        showWarning(message: "Unable to load report. Please check the Internet connection.".translate)
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


