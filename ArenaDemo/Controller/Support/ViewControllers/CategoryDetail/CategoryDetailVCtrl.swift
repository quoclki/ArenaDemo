//
//  CategoryDetailVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/4/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class CategoryDetailVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var clvCategoryDetail: UICollectionView!
    
    // MARK: - Private properties
    private var categoryDTO: CategoryDTO!
    private var lstProduct: [ProductDTO] {
        return categoryDTO.lstProduct
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ categoryDTO: CategoryDTO) {
        super.init()
        self.categoryDTO = categoryDTO
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: categoryDTO.name?.uppercased())
        addViewToLeftBarItem(createBackButton())
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
        
    }
}

extension CategoryDetailVCtrl: UICollectionViewDataSource, UICollectionViewDelegate {
    private var cellID: String {
        return String(describing: ClvProductCell.self)
    }
    
    private var backgroundColor: UIColor {
        return UIColor(hexString: "F1F2F2")
    }
    
    func configCollectionView() {
        clvCategoryDetail.backgroundColor = backgroundColor
        clvCategoryDetail.register(UINib(nibName: cellID, bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvCategoryDetail.dataSource = self
        clvCategoryDetail.delegate = self
        
        if let layout = clvCategoryDetail.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 15
            let width = Ratio.width
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            layout.itemSize = CGSize((width -  padding * 3) / 2, 265 * Ratio.ratioWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = lstProduct[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvProductCell
        cell.updateCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = lstProduct[indexPath.row]
        pushProductVCtrl(item)
    }
    
}

