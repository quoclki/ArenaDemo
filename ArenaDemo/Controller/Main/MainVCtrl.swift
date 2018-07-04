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
    @IBOutlet weak var clvMain: UICollectionView!
    
    // MARK: - Private properties
    private var lstItem: [MainDataGroup] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vAdd: searchBar)
        configSearchBar(searchBar)
        searchBar.delegate = self
        initCollectionView()
        
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
        
        _ = SEReport.getListTopSaller(request, completed: { (response) in
            let lstID = response.lstTop.map({ $0.product_id ?? -1 })
            self.getProduct(lstID)
        })
        
    }
    
    func getProduct(_ lstID: [Int]) {
        let request = GetProductRequest(page: 1)
        request.include = lstID
        
        _ = SEProduct.getListProduct(request, completed: { (response) in
            guard let group = self.lstItem.first(where: { $0.type == .topSaller }) else { return }
            group.lstProduct = response.lstProduct
            self.clvMain.reloadData()
        })
    }
    
    func getListProductCategory() {
        let request = GetCategoryRequest(page: 1)
        request.hide_empty = true
        request.per_page = 5
        
        _ = SEProduct.getListCategory(request, completed: { (response) in
            response.lstCategory.forEach({ (item) in
                self.getProductByCategoryID(item)
            })
            
        })
        
        
    }
    
    func getProductByCategoryID(_ dto: CategoryDTO) {
        let request = GetProductRequest(page: 1)
        request.category = dto.id
        
        let group = MainDataGroup()
        group.type = .category
        group.name = dto.name
        
        _ = SEProduct.getListProduct(request, completed: { (response) in
            group.lstProduct = response.lstProduct
            self.lstItem.append(group)
            self.clvMain.reloadData()
        })
        
    }
    
}

extension MainVCtrl: UICollectionViewDataSource, UICollectionViewDelegate {
    private var headerCellID: String {
        return "clvMainHeaderCellID"
    }
    private var cellID: String {
        return "clvMainCellID"
    }
    
    private var backgroundColor: UIColor {
        return UIColor(hexString: "F1F2F2")
    }
    
    func initCollectionView() {
        initData()
        configCollectionView()
    }
    
    func initData() {
        let group = MainDataGroup()
        group.type = .topSaller
        group.name = "Sản phẩm bán chạy"
        lstItem.append(group)
    }
    
    func configCollectionView() {
        clvMain.backgroundColor = backgroundColor
        clvMain.register(UINib(nibName: String(describing: ClvMainCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvMain.register(UINib(nibName: String(describing: ClvMainHeaderCell.self), bundle: Bundle(for: type(of: self))), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID)
        clvMain.dataSource = self
        clvMain.delegate = self
        
        if let layout = clvMain.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 15
            let width = Ratio.width
            layout.headerReferenceSize = CGSize(width, 58)
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset.left = padding
            layout.sectionInset.right = padding
            layout.itemSize = CGSize((width -  padding * 3) / 2, 265 * Ratio.ratioWidth)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return lstItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = lstItem[section].lstProduct.count
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
        let item = lstItem[indexPath.section].lstProduct[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvMainCell
        cell.updateCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
        
}

extension MainVCtrl: UISearchBarDelegate {
    
}

enum EMain: Int {
    case topSaller
    case category
    
}

class MainDataGroup {
    var type: EMain = .topSaller
    var name: String?
    var lstProduct: [ProductDTO] = []
    
}



