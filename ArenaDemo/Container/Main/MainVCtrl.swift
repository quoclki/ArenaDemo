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
    @IBOutlet var vActionRight: UIView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var btnCart: UIButton!
    @IBOutlet weak var tbvSlideSource: UITableView!
    
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var clvProduct: UICollectionView!
    
    // MARK: - Private properties
//    private var wkWebView: WKWebView!
//    private var progressView: UIProgressView!
    
    private var lstCategory: [CategoryDTO] = []
    private var lstProduct: [ProductDTO] = []
    private var lstProductDisplay: [ProductDTO] = []
    private var cellID = "clvProductCellID"
    
    private var searchProductText: String = "" {
        didSet {
            self.lstProductDisplay = searchProductText.trim.isEmpty ? lstProduct : lstProduct.filter({ ($0.name?.contains(s: searchProductText.trim)) ?? false })
            self.clvProduct.reloadData()
            
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCart()
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        addViewToRightBarItem(view: vActionRight)
        initCategory()
        searchBar.delegate = self
        configTableView()
        
    }
    
    func getTestOrder() {
        let request = GetOrderRequest(page: 1)
        
        _ = SEOrder.getList(request, animation: {
            self.showLoadingView($0)
        }, completed: { (response) in
            
        })
        
    }
    
    
    func initCategory() {
        let request = GetCategoryRequest(page: 1)
        
        _ = SEProduct.getListCategory(request, animation: {
            self.showLoadingView($0)
            
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            var lst = response.lstCategory
            lst.insert(self.getAllCategory(), at: 0)
            self.lstCategory = lst
            
            if let dto = self.lstCategory.first {
                self.didChooseCategory(dto: dto)
            }
        }
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
//        wkWebView.frame = self.view.bounds
//        progressView.frame.size.width = wkWebView.width
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnMenu.touchUpInside(block: btnMenu_Touched)
        btnCart.touchUpInside(block: btnCart_Touched)
        btnCategory.touchUpInside(block: btnCategory_Touched)
    }
    
    // MARK: - Event Handler
    func btnMenu_Touched(sender: UIButton) {
        Base.container.isShowMenu = !Base.container.isShowMenu
    }
    
    func btnCart_Touched(sender: UIButton) {
        if Order.shared.orderDTO.line_items.isEmpty {
            _ = showWarningAlert(message: "Please choose prudct to order")
        }
        
        let order = OrderVCtrl()
        navigationController?.pushViewController(order, animated: true)
        
    }
    
    func btnCategory_Touched(sender: UIButton) {
        let roleMenu = UIAlertController(title: "Choose Category", message: nil, preferredStyle: .actionSheet)
        lstCategory.forEach { (category) in
            let action = UIAlertAction(title: category.name, style: .default) { (action) in
                self.didChooseCategory(dto: category)
            }
            roleMenu.addAction(action)
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        roleMenu.addAction(cancelOption)
        
        if let popoverVCtrl = roleMenu.popoverPresentationController {
            popoverVCtrl.sourceView = sender
            popoverVCtrl.sourceRect = sender.bounds
        }
        
        present(roleMenu, animated: true, completion: nil)

    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    func didChooseCategory(dto: CategoryDTO) {
        btnCategory.setTitle(dto.name, for: .normal)
        let request = GetProductRequest(page: 1)
        request.category = dto.id?.toString()
        
        _ = SEProduct.getListProduct(request, animation: {
            self.showLoadingView($0)
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            self.lstProduct = response.lstProduct
            self.searchProductText = ""
            
        }

    }
    
    func updateCart() {
        let totalItem = Order.shared.totalItem
        btnCart.setTitle(totalItem.toString(), for: .normal)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension MainVCtrl: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchProductText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchProductText = ""
    }
}


extension MainVCtrl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func configTableView() {
        clvProduct.register(UINib(nibName: String(describing: ClvProductCell.self), bundle: nil), forCellWithReuseIdentifier: cellID)
        clvProduct.dataSource = self
        clvProduct.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvProductCell
        let item = lstProductDisplay[indexPath.row]
        cell.updateCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstProductDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = lstProductDisplay[indexPath.row]
        Order.shared.orderProduct(dto: item)
        updateCart()
    }
    
    func productViewInfo(indexPath: IndexPath) {
        let item = lstProductDisplay[indexPath.row]
        let productDetail = ProductDetailVCtrl(product: item)
        navigationController?.pushViewController(productDetail, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.width / 2
        
        return CGSize(width: width, height: width)
    }
    
}

//extension MainVCtrl: WKNavigationDelegate {
//    func initWKWebview() {
//        wkWebView = WKWebView(frame: self.view.bounds)
//        wkWebView.navigationDelegate = self
//        self.view.addSubview(wkWebView)
//
//        progressView = UIProgressView(progressViewStyle: .default)
//        progressView.sizeToFit()
//        wkWebView.addSubview(progressView)
//        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
//
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "estimatedProgress" {
//            progressView.progress = Float(wkWebView.estimatedProgress)
//        }
//    }
//
//    func loadWebView() {
//        let urlString = "http://xhome.com.vn"
//        if let url = URL(string: urlString) {
//            let request = URLRequest(url: url)
//            wkWebView.load(request)
//        }
//
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print(#function)
//        progressView.isHidden = false
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print(#function)
//        progressView.isHidden = true
//    }
//
//
//}


