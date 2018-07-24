//
//  ProductDetailVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/7/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import CustomControl

class ProductDetailVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var clvProductDetail: UICollectionView!
    
    @IBOutlet var vHeader: UIView!
    @IBOutlet weak var vSlideBorder: UIView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var vSlide: UIView!
    @IBOutlet weak var vPagePoint: UIView!
    @IBOutlet weak var lblNoPhoto: UILabel!
    
    @IBOutlet weak var vProductInfo: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceNormal: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    
    @IBOutlet weak var vDescribe: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet var vRight: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblTotalOrder: UILabel!
    
    @IBOutlet weak var btnOrder: UIButton!
    
    // MARK: - Private properties
    fileprivate var product: ProductDTO = ProductDTO()
    private var lstItem: [ProductDTO] = []
    
    // Image Page View Controller
    private var pageVCtrl: UIPageViewController!
    private var timerSlide: Timer = Timer()
    private var isNext: Bool = true
    private var lstImages: [Images] {
        return product.images
    }
    private var padding: CGFloat = 15
    private var quantity: Int = 0 {
        didSet {
            lblQuantity.text = quantity.toString()
            btnMinus.isEnabled = quantity > 1
            
            guard let stock_quantity = Int(product.stock_quantity ?? "") else {
                return
            }
            btnPlus.isEnabled = quantity < stock_quantity
        }
    }
    private var lineItem: OrderLineItemDTO!
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ product: ProductDTO, lineItem: OrderLineItemDTO? = nil) {
        super.init()
        self.product = product
        self.lineItem = lineItem ?? OrderLineItemDTO()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayoutUI()
    }
    
    func updateLayoutUI() {
        vSlideBorder.frame.size = CGSize(Ratio.width, Ratio.width)
        vProductInfo.originY = vSlideBorder.frame.maxY
        
        lblDescription.attributedText = product.description?.htmlAttribute
        lblDescription.sizeToFit()
        vDescribe.height = lblDescription.frame.maxY
        vDescribe.originY = vProductInfo.frame.maxY + padding
        
        // Header for Collection View
        let heightForViewHeader = vDescribe.frame.maxY + padding
        vHeader.frame = CGRect(0, -heightForViewHeader, vSafe.width, heightForViewHeader)
        clvProductDetail.addSubview(vHeader)
        clvProductDetail.contentInset.top = heightForViewHeader
        clvProductDetail.contentOffset.y = -heightForViewHeader
        
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: "CHI TIẾT SẢN PHẨM")
        configCollectionView()
        addViewToRightBarItem(vRight)
        addViewToLeftBarItem(createBackButton())
        mappingUI()
    }
    
    func mappingUI() {
        self.view.backgroundColor = backgroundColor
        lblName.text = product.name
        lblPrice.text = product.price?.toCurrencyString()
        lblPrice.textColor = Base.baseColor
        lblPriceNormal.text = product.price?.toCurrencyString()
        
        quantity = max(self.lineItem.quantity, 1)
        lineItem.product_id = product.id
        lineItem.name = product.name
        lineItem.price = product.price
        lineItem.productDTO = self.product
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        initPageViewController()
        updateCart()
    }
    
    func updateCart() {
        let totalItem = Order.shared.orderDTO.totalItem
        lblTotalOrder.text = totalItem.toString()
        lblTotalOrder.isHidden = totalItem == 0
        lblTotalOrder.cornerRadius = lblTotalOrder.height / 2
    }

    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnCart.touchUpInside(block: btnCart_Touched)
        btnFavourite.touchUpInside(block: btnFavourite_Touched)
        btnMinus.touchUpInside(block: btnMinus_Touched)
        btnPlus.touchUpInside(block: btnPlus_Touched)
        btnOrder.touchUpInside(block: btnOrder_Touched)
    }
    
    // MARK: - Event Handler
    func btnCart_Touched(sender: UIButton) {
        let order = Order.shared.orderDTO
        if order.line_items.isEmpty {
            _ = showWarningAlert(title: "Thông báo", message: "Không có sản phẩm nào trong giỏ.", buttonTitle: "OK")
            return
        }
        
        let myOrder = OrderVCtrl(order)
        myOrder.isCreateBack = true
        navigationController?.pushViewController(myOrder, animated: true)
        
    }

    func btnFavourite_Touched(sender: UIButton) {
        
    }

    func btnMinus_Touched(sender: UIButton) {
        quantity -= 1
    }
    
    func btnPlus_Touched(sender: UIButton) {
        quantity += 1
    }

    func btnOrder_Touched(sender: UIButton) {
        lineItem.quantity = quantity
        Order.shared.updateOrderLineItem(lineItem)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        getRalatedProduct()
    }
    
    func getRalatedProduct() {
        let request = GetProductRequest(page: 1)
        request.include = self.product.related_ids
        
        task = SEProduct.getListProduct(request, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            self.lstItem = response.lstProduct
            self.clvProductDetail.reloadData()
        })
    }
    
}

extension ProductDetailVCtrl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var cellID: String {
        return String(describing: ClvProductCell.self)
    }
    
    private var headerCellID: String {
        return String(describing: ClvProductHeaderCell.self)
    }
    
    private var backgroundColor: UIColor {
        return UIColor(hexString: "F1F2F2")
    }
    
    func configCollectionView() {
        clvProductDetail.backgroundColor = backgroundColor
        clvProductDetail.register(UINib(nibName: cellID, bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvProductDetail.register(UINib(nibName: headerCellID, bundle: Bundle(for: type(of: self))), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID)
        clvProductDetail.dataSource = self
        clvProductDetail.delegate = self
        
        if let layout = clvProductDetail.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            layout.itemSize = CGSize((Ratio.width -  padding * 3) / 2, 265 * Ratio.ratioWidth)
            layout.headerReferenceSize = CGSize(Ratio.width, 40)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellID, for: indexPath) as! ClvProductHeaderCell
            v.updateCell("SẢN PHẨM LIÊN QUAN")
            return v
            
        default: fatalError("Unexpected element kind")
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = lstItem[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvProductCell
        cell.updateCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = lstItem[indexPath.row]
        let detail = ProductDetailVCtrl(item)
        navigationController?.pushViewController(detail, animated: true)

    }
    
}

// For Page ViewController
extension ProductDetailVCtrl: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var selectPagePointColor: UIColor {
        return Base.baseColor
    }
    
    private var unSelectPagePointColor: UIColor {
        return .lightGray
    }

    private var selectedImage: Images? {
        return (pageVCtrl?.viewControllers?.first as? SlideVCtrl)?.image
    }
    
    func initPageViewController() {
        lblNoPhoto.isHidden = false
        if let image = product.images.first {
            lblNoPhoto.isHidden = true
            let imageSlide = SlideVCtrl(image: image)
            pageVCtrl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageVCtrl.setViewControllers([imageSlide], direction: .forward, animated: false, completion: nil)
            pageVCtrl.dataSource = self
            pageVCtrl.delegate = self
            pageVCtrl.view.frame = CGRect(0, 0, Ratio.width, Ratio.width)
            pageVCtrl.view.autoresizingMask = []
            addChildViewController(pageVCtrl)
            vSlide.cleanSubViews()
            vSlide.clipsToBounds = true
            vSlide.addSubview(pageVCtrl.view)
            initPagePoint()
            formatViewSlide()
        }
    }
    
    func initPagePoint() {
        let totalWidthPoint: CGFloat = vPagePoint.height * CGFloat(lstImages.count) * 0.7
        var startXPoint: CGFloat = Ratio.width / 2 - totalWidthPoint / 2
        vPagePoint.cleanSubViews()
        for value in lstImages.enumerated() {
            let btn = UIButton(type: .system)
            btn.frame = CGRect(startXPoint, 0, vPagePoint.height * 0.7, vPagePoint.height)
            btn.accessibilityValue = value.element.id?.toString()
            btn.touchUpInside(block: btnPoint_Touched)
            
            let v = UIView()
            v.size = CGSize(btn.width / 2, btn.width / 2)
            v.center = CGPoint(btn.width / 2, btn.height / 2)
            v.backgroundColor = unSelectPagePointColor
            v.setCircle = true
            v.borderColor = unSelectPagePointColor
            v.borderWidth = 0.5
            v.isUserInteractionEnabled = false
            btn.autoresizingMask = []
            btn.addSubview(v)
            vPagePoint.addSubview(btn)
            startXPoint += btn.width
        }
    }
    
    // UIPageViewController DataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let v = viewController as? SlideVCtrl {
            let image = v.image
            let index = lstImages.index(where: { $0.id == image.id }) ?? -1
            if index > 0 {
                return SlideVCtrl(image: lstImages[index - 1])
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let v = viewController as? SlideVCtrl {
            let image = v.image
            let index = lstImages.index(where: { $0.id == image.id }) ?? lstImages.count
            if index < lstImages.count - 1 {
                return SlideVCtrl(image: lstImages[index + 1])
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return lstImages.count
    }
    
    // Sent when a gesture-initiated transition begins.
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        //        btnPre.isUserInteractionEnabled = false
        //        btnNext.isUserInteractionEnabled = false
        
        //auto slide
        print("slide")
        vPagePoint.isUserInteractionEnabled = false
        invalidTimer()
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //        btnPre.isUserInteractionEnabled = true
        //        btnNext.isUserInteractionEnabled = true
        if finished { formatViewSlide() }
        
    }
    
    func preSlide() {
        guard let index = lstImages.index(where: { $0.id == self.selectedImage?.id }), index > 0 else {
            return
        }
        setAnimationPageViewController(index: index - 1, direction: .reverse)
    }
    
    func nextSlide() {
        guard let index = lstImages.index(where: { $0.id == self.selectedImage?.id }), index < lstImages.count - 1 else {
            return
        }
        setAnimationPageViewController(index: index + 1, direction: .forward)
    }
    
    func btnPoint_Touched(sender: UIButton) {
        guard let index = vPagePoint.subviews.index(where: { $0.accessibilityValue == sender.accessibilityValue }), sender.accessibilityValue != self.selectedImage?.id?.toString() else {
            return
        }
        let indexPrevious = vPagePoint.subviews.index(where: { $0.subviews.first?.backgroundColor == self.selectPagePointColor }) ?? -1
        setAnimationPageViewController(index: index, direction: index > indexPrevious ? .forward : .reverse)
    }
    
    func setAnimationPageViewController(index: Int, direction: UIPageViewControllerNavigationDirection) {
        let image = lstImages[index]
        let imageSlide = SlideVCtrl(image: image)
        
        self.view.isUserInteractionEnabled = false
        invalidTimer()
        pageVCtrl.setViewControllers([imageSlide], direction: direction, animated: true, completion: { finish in
            self.view.isUserInteractionEnabled = true
            if finish {
                self.formatViewSlide()
            }
        })
    }
    
    /// Format Label Page No
    func formatViewSlide() {
        guard let image = self.selectedImage else {
            return
        }
        vPagePoint.isUserInteractionEnabled = true
        vPagePoint.subviews.forEach { (v) in
            guard let btn = v.subviews.first else {
                return
            }
            btn.backgroundColor = Int(v.accessibilityValue ?? "") == image.id ? selectPagePointColor : unSelectPagePointColor
        }
        
        //        guard let index = lstPromotion.index(where: { $0.id == promo.id }) else { return }
        //        btnPre.isHidden = index == 0
        //        btnNext.isHidden = index == lstPromotion.count - 1
        invalidTimer()
        
    }
    
    func invalidTimer() {
        if getVCtrlInNavigation(ProductDetailVCtrl.self) == nil {
            timerSlide.invalidate()
            return
        }
        
        if lstImages.count == 1 {
            return
        }
        timerSlide.invalidate()
        timerSlide = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: false)
        
    }
    
    @objc func handleTimer(_ timer: Timer) {
        guard let index = lstImages.index(where: { $0.id == self.selectedImage?.id }), vPagePoint.isUserInteractionEnabled else {
            return
        }
        
        if index == 0 {
            self.isNext = true
        }
        if index == lstImages.count - 1 {
            self.isNext = false
        }
        
        isNext ? nextSlide() : preSlide()
        
    }
}


