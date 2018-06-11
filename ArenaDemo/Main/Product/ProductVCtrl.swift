//
//  ProductVCtrl.swift
//  App199k
//
//  Created by Lu Kien Quoc on 6/7/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class ProductVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var clvProduct: UICollectionView!
    
    // MARK: - Private properties
    fileprivate var productCellID = "productID"

    // MARK: - Properties
    var lstProduct: [ProductDTO] = []
    
    // MARK: - Init
    init(lstProduct: [ProductDTO]) {
        super.init()
        self.lstProduct = lstProduct
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Product"
        configTableView()
    }
    
    func configTableView() {
        clvProduct.register(UINib(nibName: String(describing: ClvProductCell.self), bundle: nil), forCellWithReuseIdentifier: productCellID)
        clvProduct.dataSource = self
        clvProduct.delegate = self
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
        
    }
}

extension ProductVCtrl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellID, for: indexPath) as! ClvProductCell
        let item = lstProduct[indexPath.row]
        cell.updateCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = lstProduct[indexPath.row]
        let productDetail = ProductDetailVCtrl(product: item)
        navigationController?.pushViewController(productDetail, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = bounds.width / 2
        
        return CGSize(width: width, height: width)
    }
   
}
