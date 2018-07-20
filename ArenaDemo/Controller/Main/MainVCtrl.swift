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
        getListTopSales()
        getListProductCategory()
    }
    
    func getListTopSales() {
        let request = GetReportRequest(page: 1)
        request.period = EReportPeriod.last_month.rawValue
        
        task = SEReport.getListTopSaller(request, completed: { (response) in
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
        return "clvMainHeaderCellID"
    }
    private var cellID: String {
        return "clvMainCellID"
    }
    
    private var backgroundColor: UIColor {
        return UIColor(hexString: "F1F2F2")
    }
        
    func configCollectionView() {
        clvMain.backgroundColor = backgroundColor
        clvMain.register(UINib(nibName: String(describing: ClvProductCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvMain.register(UINib(nibName: String(describing: ClvMainHeaderCell.self), bundle: Bundle(for: type(of: self))), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID)
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
        let count = lstItem[section].category.lstProduct.count
        return count % 2 == 0 ? count : count - 1
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
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



