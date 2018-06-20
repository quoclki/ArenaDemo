//
//  ProductDetailVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/7/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class ProductDetailVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var vSlide: UIView!
    @IBOutlet weak var vPagePoint: UIView!
    @IBOutlet weak var lblNoPhoto: UILabel!
    
    @IBOutlet weak var vBody: UIView!
    @IBOutlet weak var tbvReview: UITableView!
    @IBOutlet var btnRight: UIButton!
    
    // MARK: - Private properties
    fileprivate var lstReview: [ReviewDTO] = []
    fileprivate var product: ProductDTO = ProductDTO()
    
    private var pageVCtrl: UIPageViewController!
    private var timerSlide: Timer = Timer()
    private var isNext: Bool = true
    
    private var lstImages: [Images] {
        return product.images
    }
    private var selectPagePointColor: UIColor = .white
    private var unSelectPagePointColor: UIColor = .lightGray

    private var reviewCellID: String = "reviewCellID"
    
    private var isReview: Bool = false {
        didSet {
            btnRight.setTitle(isReview ? "Review" : "Info", for: .normal)
            let width = UIScreen.main.bounds.width
            UIView.animate(withDuration: 0.3) {
                self.vBody.originX = self.isReview ? -width : 0
            }
        }
    }
    
    // MARK: - Properties
    
    // MARK: - Init
    init(product: ProductDTO) {
        super.init()
        self.product = product
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = product.name
        lblDescription.attributedText = product.description?.htmlAttribute
        lblPrice.attributedText = product.price_html?.htmlAttribute
        
        configTableView()
        isReview = false
        
        addViewToRightBarItem(view: btnRight)
    }

    func configTableView() {
        tbvReview.register(UINib(nibName: String(describing: TbvReviewCell.self), bundle: nil), forCellReuseIdentifier: reviewCellID)
        tbvReview.dataSource = self
        tbvReview.delegate = self
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        initPageViewController()

    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnRight.touchUpInside(block: btnRight_Touched)
    }
    
    // MARK: - Event Handler
    func btnRight_Touched(sender: UIButton) {
        isReview = !isReview
    }

    // MARK: - Func
    override func loadData() {
        super.loadData()
        getReviewData()
    }
    
    func getReviewData() {
        guard let id = self.product.id else { return }
        _ = SEProduct.getReview(id, animation: {
            self.showLoadingView($0)
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }

            let lst = response.lstReview
            self.lstReview = lst
            self.tbvReview.reloadData()
            
        }
        
    }
    
}

// For Page ViewController
extension ProductDetailVCtrl: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
            pageVCtrl.view.frame = vSlide.bounds
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
        var startXPoint: CGFloat = vPagePoint.center.x - totalWidthPoint / 2
        vPagePoint.cleanSubViews()
        for value in lstImages.enumerated() {
            let btn = UIButton(type: .system)
            btn.frame = CGRect(startXPoint, 0, vPagePoint.height * 0.7, vPagePoint.height)
            btn.accessibilityValue = value.element.id?.toString()
            btn.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
            btn.touchUpInside(block: btnPoint_Touched)
            
            let v = UIView()
            v.size = CGSize(btn.width / 2, btn.width / 2)
            v.center = CGPoint(btn.width / 2, btn.height / 2)
            v.backgroundColor = unSelectPagePointColor
            v.setCircle = true
            v.borderColor = unSelectPagePointColor
            v.borderWidth = 0.5
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
        guard let index = lstImages.index(where: { $0.id == self.selectedImage?.id }), index > 0 else { return }
        setAnimationPageViewController(index: index - 1, direction: .reverse)
    }
    
    func nextSlide() {
        guard let index = lstImages.index(where: { $0.id == self.selectedImage?.id }), index < lstImages.count - 1 else { return }
        setAnimationPageViewController(index: index + 1, direction: .forward)
    }
    
    func btnPoint_Touched(sender: UIButton) {
        guard let index = vPagePoint.subviews.index(where: { $0.accessibilityValue == sender.accessibilityValue }) else { return }
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
        guard let image = self.selectedImage else { return }
        vPagePoint.isUserInteractionEnabled = true
        vPagePoint.subviews.forEach { (v) in
            guard let btn = v.subviews.first else { return }
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
        
        if lstImages.count == 1 { return }
        timerSlide.invalidate()
        timerSlide = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: false)
        
    }
    
    @objc func handleTimer(_ timer: Timer) {
        guard let index = lstImages.index(where: { $0.id == self.selectedImage?.id }), vPagePoint.isUserInteractionEnabled else { return }
        
        if index == 0 {
            self.isNext = true
        }
        if index == lstImages.count - 1 {
            self.isNext = false
        }
        
        isNext ? nextSlide() : preSlide()
        
    }
}

// For Review source
extension ProductDetailVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellID) as! TbvReviewCell
        let item = lstReview[indexPath.row]
        cell.updateCell(item: item)
        return cell
    }
    
    
    
}



