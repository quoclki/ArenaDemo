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
    var isCreateBack: Bool = false
    
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
        if isCreateBack {
            addViewToLeftBarItem(createBackButton())
        }
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

extension OrderVCtrl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var cellID: String {
        return "clvOrderCellID"
    }
    
    private var paymentCellID: String {
        return "clvOrderPaymentCellID"
    }
    
    private var padding: CGFloat {
        return 15
    }
    
    func configCollectionView() {
        clvOrder.backgroundColor = .white
        clvOrder.register(UINib(nibName: String(describing: ClvOrderCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvOrder.register(UINib(nibName: String(describing: ClvOrderPaymentCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: paymentCellID)
        clvOrder.dataSource = self
        clvOrder.delegate = self
        
        if let layout = clvOrder.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstItem.isEmpty ? 0 : lstItem.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == lstItem.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: paymentCellID, for: indexPath) as! ClvOrderPaymentCell
            cell.updateCell()
            return cell
        }
        
        let item = lstItem[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvOrderCell
        cell.updateCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == lstItem.count {
            return
        }
        
        let item = lstItem[indexPath.row]
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Ratio.width
        let widthItem = width - padding * 2
        return CGSize(widthItem, indexPath.row == lstItem.count ? 102 : 152)

    }
    
    func handleDelete(_ collectionView: UICollectionView, indexPath: IndexPath) {
        _ = showAlert(title: "Cảnh báo", message: "Bạn có chắc chắn muốn xoá món hàng này?", leftBtnTitle: "Không", rightBtnTitle: "Có", rightBtnStyle: .destructive, rightAction: {
            self.order.line_items.remove(at: indexPath.row)
            collectionView.reloadData()
            
        })
        
    }
    
}

