//
//  CategoryVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/4/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class CategoryVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var clvCategory: UICollectionView!
    
    // MARK: - Private properties
    private var lstCategory: [CategoryDTO] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func

    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(searchBar: searchBar)
        configSearchBar(searchBar)
        initCollectionView()
        vSetSafeArea = clvCategory
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
        getCategory()
    }
    
    func getCategory() {
        let request = GetCategoryRequest(page: 1)
        request.orderby = EProductCategoryOrderBy.name.rawValue
        
        _ = SEProduct.getListCategory(request, animation: { (isShow) in
            self.showLoadingView(isShow)
            self.vBar.isUserInteractionEnabled = !isShow
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }

            self.lstCategory = response.lstCategory
            self.clvCategory.reloadData()
            
        })
        
    }
    
}

extension CategoryVCtrl: UICollectionViewDataSource, UICollectionViewDelegate {
    private var cellID: String {
        return "clvCategoryCellID"
    }
    
    func initCollectionView() {
        configCollectionView()
    }
    
    func configCollectionView() {
        clvCategory.backgroundColor = .white
        clvCategory.register(UINib(nibName: String(describing: ClvCategoryCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvCategory.dataSource = self
        clvCategory.delegate = self
        
        if let layout = clvCategory.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 15
            let width = Ratio.width
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            
            let widthItem = (width - padding * 3) / 2
            layout.itemSize = CGSize(widthItem, widthItem)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = lstCategory[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvCategoryCell
        cell.updateCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = lstCategory[indexPath.row]
        
        let request = GetProductRequest(page: 1)
        request.category = item.id

        _ = SEProduct.getListProduct(request, animation: { (isShow) in
            self.showLoadingView(isShow, frameLoading: collectionView.frame)
            self.vBar.isUserInteractionEnabled = !isShow
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            item.lstProduct = response.lstProduct
            let detail = CategoryDetailVCtrl(item)
            self.navigationController?.pushViewController(detail, animated: true)
        })
        
    }
    
}

