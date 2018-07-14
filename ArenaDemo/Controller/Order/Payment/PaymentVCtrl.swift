//
//  PaymentVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/12/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class PaymentVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var clvOrder: UICollectionView!
    @IBOutlet weak var btnOrder: UIButton!

    @IBOutlet var vPayment: UIView!
    @IBOutlet weak var vInfoPayment: UIView!
    @IBOutlet weak var vSignUp: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var txtName: CustomUITextField!
    @IBOutlet weak var txtPhone: CustomUITextField!
    @IBOutlet weak var txtEmail: CustomUITextField!
    @IBOutlet weak var txtAddress: CustomUITextField!
    @IBOutlet weak var txvNote: UITextView!
    
    @IBOutlet var vPaymentFooter: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    
    // MARK: - Private properties
    
    // MARK: - Properties
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
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayoutUI()
    }

    func updateLayoutUI() {
        self.view.backgroundColor = UIColor(hexString: "F1F2F2")
        if Order.shared.cusDTO.id != nil {
            Order.shared.setUpCustomer()
            vSignUp.isHidden = true
            vInfoPayment.originY = 0
        }
        
        vPayment.height = vInfoPayment.frame.maxY + padding
        
        // Header for Collection View
        let heightForViewHeader = vPayment.height
        vPayment.frame = CGRect(0, -heightForViewHeader, Ratio.width, heightForViewHeader)
        clvOrder.addSubview(vPayment)
        clvOrder.contentInset.top = heightForViewHeader
        clvOrder.contentOffset.y = -heightForViewHeader
    }

    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(title: "THANH TOÁN")
        vSetSafeArea = vSafe
        addViewToLeftBarItem(createBackButton())
        configCollectionView()

        updateLayoutUI()
        mappingUI()
    }
    
    func mappingUI() {
        txtName.text = [order.billing?.first_name ?? "", order.billing?.last_name ?? ""].filter({ !$0.isEmpty }).joined(separator: " ")
        txtPhone.text = order.billing?.phone
        txtEmail.text = order.billing?.email
        txtAddress.text = order.billing?.address_1
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

extension PaymentVCtrl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var cellID: String {
        return "clvPaymentOrderCellID"
    }
    
    private var paymentCellID: String {
        return "clvPaymentPaymentCellID"
    }
    
    private var headerCellID: String {
        return "clvPaymentHeaderCellID"
    }
    
    private var padding: CGFloat {
        return 15
    }
    
    func configCollectionView() {
        clvOrder.backgroundColor = .white
        clvOrder.register(UINib(nibName: String(describing: ClvOrderCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvOrder.register(UINib(nibName: String(describing: ClvOrderPaymentCell.self), bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: paymentCellID)
        clvOrder.register(UINib(nibName: String(describing: ClvProductHeaderCell.self), bundle: Bundle(for: type(of: self))), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID)
        clvOrder.dataSource = self
        clvOrder.delegate = self
        
        if let layout = clvOrder.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            layout.headerReferenceSize = CGSize(Ratio.width, 40)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstItem.isEmpty ? 0 : lstItem.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellID, for: indexPath) as! ClvProductHeaderCell
            v.updateCell("ĐƠN HÀNG CỦA BẠN")
            return v
            
        default: fatalError("Unexpected element kind")
        }
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
        
        //        let item = lstItem[indexPath.row]
        
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

