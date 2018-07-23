//
//  MainVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/2/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class MainVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var clvMain: UICollectionView!
    
    // MARK: - Private properties
    private var lstItem: [MainDataGroup] = []
    private var lstItem_Display: [MainDataGroup] = []
    
    private var searchText: String = "" {
        didSet {
            if searchText.trim().isEmpty {
                lstItem_Display = lstItem
                clvMain.reloadData()
                return
            }
            
            lstItem_Display.removeAll()
            lstItem.forEach { (item) in
                if let category = CategoryDTO.fromJson(item.category.toJson()) {
                    category.lstProduct = item.category.lstProduct.filter({ $0.name?.contains(s: searchText) ?? false })

                    if !category.lstProduct.isEmpty {
                        let group = MainDataGroup()
                        group.type = item.type
                        group.category = category
                        self.lstItem_Display.append(group)
                    }
                }
            }
            
            clvMain.reloadData()
            
        }
    }
    
    private var totalGetService: Int = 0 {
        didSet {
            print("Total get service: \( totalGetService )")
            if totalGetService == 0 {
                searchBar.isUserInteractionEnabled = false
                return
            }
            
            if totalGetService == lstItem.count || totalGetService == 2 {
                searchBar.isUserInteractionEnabled = true
            }
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, searchBar: searchBar)
        searchBar.delegate = self
        configCollectionView()
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
        totalGetService = 0
        getListTopSales()
        getListProductCategory()
    }
    
    func getListTopSales() {
        let request = GetReportRequest(page: 1)
        request.period = EReportPeriod.last_month.rawValue
        
        task = SEReport.getListTopSaller(request, completed: { (response) in
            if !response.success {
                self.totalGetService += 1
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
            
            self.totalGetService += 1
            let category = CategoryDTO()
            category.name = "Sản phẩm bán chạy"
            category.isTopSaller = true
            category.lstProduct = response.lstProduct
            
            let group = MainDataGroup()
            group.category = category
            group.type = .topSaller
            self.lstItem.insert(group, at: 0)
            self.lstItem_Display = self.lstItem
            self.clvMain.insertSections(IndexSet(integer: 0))
        })
    }
    
    func getListProductCategory() {
        let request = GetCategoryRequest(page: 1)
        request.hide_empty = true
        request.per_page = 5
        
        task = SEProduct.getListCategory(request, completed: { (response) in
            if !response.success {
                self.totalGetService += 1
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

            self.totalGetService += 1
            dto.lstProduct = response.lstProduct
            
            let group = MainDataGroup()
            group.type = .category
            group.category = dto
            
            let section = self.lstItem.count
            self.lstItem.insert(group, at: section)
            self.lstItem_Display = self.lstItem
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
        return lstItem_Display.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstItem_Display[section].category.lstProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let item = lstItem_Display[indexPath.section]
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellID, for: indexPath) as! ClvMainHeaderCell
            v.backgroundColor = .clear
            v.updateCell(item)
            return v
            
        default: fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = lstItem_Display[indexPath.section].category.lstProduct[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvProductCell
        cell.updateCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = lstItem_Display[indexPath.section].category.lstProduct[indexPath.row]
        let detail = ProductDetailVCtrl(item)
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(collectionView.width, section == 0 ? 40 : 25)
    }
    
}

extension MainVCtrl: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.searchText = ""
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



