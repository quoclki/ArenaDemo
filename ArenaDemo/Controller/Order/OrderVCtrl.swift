//
//  OrderVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/9/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class OrderVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var clvOrder: UICollectionView!
    
    // MARK: - Private properties
    private var order: OrderDTO!
    private var lstItem: [OrderLineItemDTO] {
        return order.line_items
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ order: OrderDTO) {
        super.init()
        self.order = order
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(title: "GIỎ HÀNG CỦA TÔI")
        vSetSafeArea = vSafe
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

extension OrderVCtrl: UICollectionViewDataSource, UICollectionViewDelegate {
    private var cellID: String {
        return "clvOrderCellID"
    }
    
    private var paymentCellID: String {
        return "clvOrderPaymentCellID"
    }
    
    func configCollectionView() {
        clvOrder.backgroundColor = .white
        clvOrder.register(UINib(nibName: String(describing: ClvOrderCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvOrder.register(UINib(nibName: String(describing: ClvOrderPaymentCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: paymentCellID)
        clvOrder.dataSource = self
        clvOrder.delegate = self
        
        if let layout = clvOrder.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 15
            let width = Ratio.width
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            
            let widthItem = width - padding * 2
            layout.itemSize = CGSize(widthItem, 152)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = lstItem[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvOrderCell
        cell.updateCell(item)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = lstItem[indexPath.row]
//        
//        
//    }
    
}

