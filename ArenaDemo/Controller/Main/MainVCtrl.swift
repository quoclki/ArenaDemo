//
//  MainVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/2/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import WebKit

class MainVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var clvMain: UICollectionView!
    
    @IBOutlet var vHeader: UIView!
    
    // MARK: - Private properties
    private var lstItem: [MainDataGroup] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayoutCollectionView()
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, searchBar: searchBar)
        searchBar.delegate = self
        configCollectionView()
        configWebView()
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
    func configWebView() {
        vSafe.clipsToBounds = true
        vHeader.cleanSubViews()
        
        let web = WKWebView()
        web.frame = vHeader.bounds
        web.autoresizingMask = vSafe.autoresizingMask
        web.isUserInteractionEnabled = false
        if let url = URL(string: SEBase.apiURL) {
            let request = URLRequest(url: url)
            web.load(request)
        }
        
        web.backgroundColor = .white
        web.navigationDelegate = self
        vHeader.addSubview(web)
        
    }
    
    func updateLayoutCollectionView() {
        // Header for Collection View
        vHeader.originY = -vHeader.height
        vHeader.width = self.view.width
        vHeader.clipsToBounds = true
        clvMain.addSubview(vHeader)
        clvMain.contentInset.top = vHeader.height
        clvMain.contentOffset.y = -vHeader.height
        
    }
    
    override func loadData() {
        super.loadData()
        getListTopSales()
        getListProductCategory()
    }
    
    func getListTopSales() {
        let request = GetReportRequest(page: 1)
        request.period = EReportPeriod.last_month.rawValue
        
        task = SEReport.getListTopSaller(request, completed: { (response) in
            if !response.success {
                return
            }

            let lstID = response.lstTop.map({ $0.product_id ?? -1 })
            self.getProduct(lstID)
        })
        
    }
    
    func getProduct(_ lstID: [Int]) {
        let request = GetProductRequest(page: 1)
        request.include = lstID
        
        task = SEProduct.getListProduct(request, completed: { (response) in
            if !response.success {
                return
            }
            
            if let last = response.lstProduct.last, response.lstProduct.count % 2 == 1 {
                response.lstProduct.remove(last)
            }
            
            if response.lstProduct.isEmpty {
                return
            }
            
            let category = CategoryDTO()
            category.name = "Sản phẩm bán chạy"
            category.isTopSaller = true
            category.lstProduct = response.lstProduct
            
            let group = MainDataGroup()
            group.category = category
            group.type = .topSaller
            self.lstItem.insert(group, at: 0)
            self.clvMain.insertSections(IndexSet(integer: 0))
        })
    }
    
    func getListProductCategory() {
        let request = GetCategoryRequest(page: 1)
        request.hide_empty = true
        request.per_page = 5
        
        task = SEProduct.getListCategory(request, completed: { (response) in
            if !response.success {
                return
            }

            response.lstCategory.forEach({ (item) in
                self.getProductByCategoryID(item)
            })
            
        })
        
    }
    
    func getProductByCategoryID(_ dto: CategoryDTO) {
        let request = GetProductRequest(page: 1)
        request.category = dto.id
        
        task = SEProduct.getListProduct(request, completed: { (response) in
            if !response.success {
                return
            }
            
            if let last = response.lstProduct.last, response.lstProduct.count % 2 == 1 {
                response.lstProduct.remove(last)
            }
            
            if response.lstProduct.isEmpty {
                return
            }

            dto.lstProduct = response.lstProduct
            
            let group = MainDataGroup()
            group.type = .category
            group.category = dto
            
            let section = self.lstItem.count
            self.lstItem.insert(group, at: section)
            self.clvMain.insertSections(IndexSet(integer: section))

        })
        
    }
    
}

extension MainVCtrl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var headerCellID: String {
        return String(describing: ClvMainHeaderCell.self)
    }
    private var cellID: String {
        return String(describing: ClvProductCell.self)
    }
    
    private var backgroundColor: UIColor {
        return UIColor(hexString: "F1F2F2")
    }
        
    func configCollectionView() {
        vHeader.backgroundColor = backgroundColor
        clvMain.backgroundColor = backgroundColor
        clvMain.register(UINib(nibName: cellID, bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvMain.register(UINib(nibName: headerCellID, bundle: Bundle(for: type(of: self))), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID)
        clvMain.dataSource = self
        clvMain.delegate = self
        
        if let layout = clvMain.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 15
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            layout.itemSize = CGSize((Ratio.width -  padding * 3) / 2, 265 * Ratio.ratioWidth)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return lstItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstItem[section].category.lstProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let item = lstItem[indexPath.section]
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellID, for: indexPath) as! ClvMainHeaderCell
            v.backgroundColor = .clear
            v.updateCell(item)
            return v
            
        default: fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = lstItem[indexPath.section].category.lstProduct[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvProductCell
        cell.updateCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = lstItem[indexPath.section].category.lstProduct[indexPath.row]
        pushProductVCtrl(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(collectionView.width, section == 0 ? 40 : 25)
    }
    
}

extension MainVCtrl: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let search = ProductSearchVCtrl(searchBar.text)
        navigationController?.pushViewController(search, animated: true)
        searchBarCancelButtonClicked(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

extension MainVCtrl: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        vHeader.showLoadingView(loadingBgColor: vHeader.backgroundColor ?? .white)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        vHeader.showLoadingView(false)
        webView.scrollView.contentInset.top = -100 * Ratio.ratioWidth
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
}


enum EMain: Int {
    case topSaller
    case category
    
}

class MainDataGroup {
    var type: EMain = .topSaller
    var category: CategoryDTO = CategoryDTO()
    
}



