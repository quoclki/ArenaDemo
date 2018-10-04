//
//  MainVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/2/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import WebKit

class MainVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var clvMain: UICollectionView!
    
    @IBOutlet var vHeader: UIView!
    @IBOutlet var vSlide: UIView!
    @IBOutlet var vPagePoint: UIView!

    // MARK: - Private properties
    private var lstItem: [MainDataGroup] = []
    
    // properties for PageVCtrl
    private var pageVCtrl: UIPageViewController!
    private var timerSlide: Timer = Timer()
    private var isNext: Bool = true
    private var lstItemSlide: [MainSlideData] = []

    // MARK: - Properties
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Base.container.setHiddenAnimationMenu(true)
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, searchBar: searchBar)
        searchBar.delegate = self
        configCollectionView()
        updateLayoutCollectionView()
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        Base.container.setHiddenAnimationMenu(false)
        initPageViewController()
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
//    func configWebView() {
//        vSafe.clipsToBounds = true
//        vHeader.cleanSubViews()
//
//        let web = WKWebView()
//        web.frame = vHeader.bounds
//        web.autoresizingMask = vSafe.autoresizingMask
//        web.isUserInteractionEnabled = false
//        if let url = URL(string: SEBase.apiURL) {
//            let request = URLRequest(url: url)
//            web.load(request)
//        }
//
//        web.backgroundColor = .white
//        web.navigationDelegate = self
//        vHeader.addSubview(web)
//
//    }
    
    func updateLayoutCollectionView() {
        // Header for Collection View
        vHeader.width = Ratio.width
        vHeader.height = vHeader.width / 2
        vHeader.originY = -vHeader.height
        vHeader.originX = 0
        vHeader.clipsToBounds = true
        clvMain.addSubview(vHeader)
        clvMain.contentInset.top = vHeader.height
        clvMain.contentOffset.y = -vHeader.height
        
    }
    
    override func loadData() {
        super.loadData()
        getListTopSales()
        getListProductCategory()
        setupDataForPageViewController()
    }
    
    func getListTopSales() {
        let request = GetReportRequest(page: 1)
        request.period = EReportPeriod.last_month.rawValue
        
        task = SEReport.getListTopSaller(request, completed: { (response) in
            if !response.success {
                return
            }

            let lstID = response.lstTop.map({ $0.product_id ?? -1 }).prefix(10).map({ $0 })
            if lstID.isEmpty {
                return
            }
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
            
            if let last = response.lstProduct.last, response.lstProduct.count % 2 == 1 {
                response.lstProduct.remove(last)
            }
            
            if response.lstProduct.isEmpty {
                return
            }
            
            if let section = self.lstItem.index(where: { $0.type == .topSaller }) {
                self.lstItem[section].category.lstProduct = response.lstProduct
                self.clvMain.reloadSections(IndexSet(integer: section))
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
        request.per_page = 4
        
        task = SEProduct.getListProduct(request, completed: { (response) in
            if !response.success {
                return
            }
            
            if let last = response.lstProduct.last, response.lstProduct.count % 2 == 1 {
                response.lstProduct.remove(last)
            }
            
            if response.lstProduct.isEmpty {
                return
            }

            if let section = self.lstItem.index(where: { $0.type == .category && $0.category.id == dto.id }) {
                self.lstItem[section].category.lstProduct = response.lstProduct
                self.clvMain.reloadSections(IndexSet(integer: section))
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
    
    func setupDataForPageViewController() {
        self.lstItemSlide.removeAll()
        var img = MainSlideData()
        img.id = lstItemSlide.count.toString()
        img.img = UIImage(named: "img-s1", in: Bundle(for: Base.self), compatibleWith: nil)
        img.categoryID = 121
        img.categoryName = "VÁY, ĐẦM"
        self.lstItemSlide.append(img)

        img = MainSlideData()
        img.id = lstItemSlide.count.toString()
        img.img = UIImage(named: "img-s2", in: Bundle(for: Base.self), compatibleWith: nil)
        img.categoryID = 120
        img.categoryName = "ÁO SƠ MI"
        self.lstItemSlide.append(img)
        
        img = MainSlideData()
        img.id = lstItemSlide.count.toString()
        img.img = UIImage(named: "img-s3", in: Bundle(for: Base.self), compatibleWith: nil)
        img.categoryID = 124
        img.categoryName = "BIKINI"
        self.lstItemSlide.append(img)
    }
}

extension MainVCtrl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var headerCellID: String {
        return String(describing: ClvMainHeaderCell.self)
    }
    private var cellID: String {
        return String(describing: ClvProductCell.self)
    }
    
    private var backgroundColor: UIColor {
        return UIColor(hexString: "F1F2F2")
    }
        
    func configCollectionView() {
        vHeader.backgroundColor = backgroundColor
        clvMain.backgroundColor = backgroundColor
        clvMain.register(UINib(nibName: cellID, bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvMain.register(UINib(nibName: headerCellID, bundle: Bundle(for: type(of: self))), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellID)
        clvMain.dataSource = self
        clvMain.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .black
        clvMain.alwaysBounceVertical = true
        if #available(iOS 10.0, *) {
            clvMain.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            clvMain.addSubview(refreshControl)
        }
        
        if let layout = clvMain.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 15
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            layout.itemSize = CGSize((Ratio.width -  padding * 3) / 2, 265 * Ratio.ratioWidth)
        }
    }
    
    @objc func handleRefresh(_ refresh: UIRefreshControl) {
        print(#function)
        refresh.endRefreshing()
        self.lstItem.removeAll()
        self.clvMain.reloadData()
        self.loadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return lstItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstItem[section].category.lstProduct.count
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
        pushProductVCtrl(item) {
            collectionView.showLoadingView($0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(collectionView.width, section == 0 ? 40 : 25)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
//        print(vHeader.originY)
        if scrollView.contentOffset.y > -vHeader.height {
            vHeader.originY = -vHeader.height
            return
        }
        vHeader.originY = scrollView.contentOffset.y
    }
    
}

extension MainVCtrl: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let search = ProductSearchVCtrl(searchBar.text)
        navigationController?.pushViewController(search, animated: true)
        searchBarCancelButtonClicked(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

extension MainVCtrl: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        vHeader.showLoadingView(loadingBgColor: vHeader.backgroundColor ?? .white)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        vHeader.showLoadingView(false)
        webView.scrollView.contentInset.top = -100 * Ratio.ratioWidth
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
}

// For Page ViewController
extension MainVCtrl: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var selectPagePointColor: UIColor {
        return Base.baseColor
    }
    
    private var unSelectPagePointColor: UIColor {
        return .lightGray
    }
    
    private var selectedSlide: MainSlideData? {
        return (pageVCtrl?.viewControllers?.first as? MainSlideVCtrl)?.slideItem
    }
    
    func initPageViewController() {
        if let slideItem = lstItemSlide.first {
            let imageSlide = MainSlideVCtrl(slideItem)
            imageSlide.handleSelect = handleSelectItem
            pageVCtrl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageVCtrl.setViewControllers([imageSlide], direction: .forward, animated: false, completion: nil)
            pageVCtrl.dataSource = self
            pageVCtrl.delegate = self
            pageVCtrl.view.frame = CGRect(0, 0, vHeader.width, vHeader.height)
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
        let totalWidthPoint: CGFloat = vPagePoint.height * CGFloat(lstItemSlide.count) * 0.7
        var startXPoint: CGFloat = Ratio.width / 2 - totalWidthPoint / 2
        vPagePoint.cleanSubViews()
        for value in lstItemSlide.enumerated() {
            let btn = UIButton(type: .system)
            btn.frame = CGRect(startXPoint, 0, vPagePoint.height * 0.7, vPagePoint.height)
            btn.accessibilityValue = value.element.id
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
        if let v = viewController as? MainSlideVCtrl {
            let slideItem = v.slideItem
            let index = lstItemSlide.index(where: { $0.id == slideItem?.id }) ?? -1
            if index > 0 {
                let vctrl = MainSlideVCtrl(lstItemSlide[index - 1])
                vctrl.handleSelect = handleSelectItem
                return vctrl
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let v = viewController as? MainSlideVCtrl {
            let slideItem = v.slideItem
            let index = lstItemSlide.index(where: { $0.id == slideItem?.id }) ?? lstItemSlide.count
            if index < lstItemSlide.count - 1 {
                let vctrl = MainSlideVCtrl(lstItemSlide[index + 1])
                vctrl.handleSelect = handleSelectItem
                return vctrl
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return lstItemSlide.count
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
        guard let index = lstItemSlide.index(where: { $0.id == self.selectedSlide?.id }), index > 0 else {
            return
        }
        setAnimationPageViewController(index: index - 1, direction: .reverse)
    }
    
    func nextSlide() {
        guard let index = lstItemSlide.index(where: { $0.id == self.selectedSlide?.id }), index < lstItemSlide.count - 1 else {
            return
        }
        setAnimationPageViewController(index: index + 1, direction: .forward)
    }
    
    func btnPoint_Touched(sender: UIButton) {
        guard let index = vPagePoint.subviews.index(where: { $0.accessibilityValue == sender.accessibilityValue }), sender.accessibilityValue != self.selectedSlide?.id?.toString() else {
            return
        }
        let indexPrevious = vPagePoint.subviews.index(where: { $0.subviews.first?.backgroundColor == self.selectPagePointColor }) ?? -1
        setAnimationPageViewController(index: index, direction: index > indexPrevious ? .forward : .reverse)
    }
    
    func setAnimationPageViewController(index: Int, direction: UIPageViewControllerNavigationDirection) {
        let slideItem = lstItemSlide[index]
        let imageSlide = MainSlideVCtrl(slideItem)
        imageSlide.handleSelect = handleSelectItem
        
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
        guard let selectedSlide = self.selectedSlide else {
            return
        }
        vPagePoint.isUserInteractionEnabled = true
        vPagePoint.subviews.forEach { (v) in
            guard let btn = v.subviews.first else {
                return
            }
            btn.backgroundColor = v.accessibilityValue == selectedSlide.id ? selectPagePointColor : unSelectPagePointColor
        }
        
        //        guard let index = lstPromotion.index(where: { $0.id == promo.id }) else { return }
        //        btnPre.isHidden = index == 0
        //        btnNext.isHidden = index == lstPromotion.count - 1
        invalidTimer()
        
    }
    
    func invalidTimer() {
        if getVCtrlInNavigation(MainVCtrl.self) == nil {
            timerSlide.invalidate()
            return
        }
        
        if lstItemSlide.count == 1 {
            return
        }
        timerSlide.invalidate()
        timerSlide = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(handleTimer(_:)), userInfo: nil, repeats: false)
        
    }
    
    @objc func handleTimer(_ timer: Timer) {
        guard let index = lstItemSlide.index(where: { $0.id == self.selectedSlide?.id }), vPagePoint.isUserInteractionEnabled else {
            return
        }
        
        if index == 0 {
            self.isNext = true
        }
        if index == lstItemSlide.count - 1 {
            self.isNext = false
        }
        
        isNext ? nextSlide() : preSlide()
        
    }

    func handleSelectItem(_ category: CategoryDTO) {
        let request = GetProductRequest(page: 1)
        request.category = category.id
        
        task = SEProduct.getListProduct(request, animation: { (isShow) in
            self.pageVCtrl?.view.showLoadingView(isShow)
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            if response.lstProduct.isEmpty {
                _ = self.showWarningAlert(title: "Thông báo", message: "Không có sản phẩm nào trong danh mục này.", buttonTitle: "OK")
                return
            }
            
            category.lstProduct = response.lstProduct
            let detail = CategoryDetailVCtrl(category)
            self.navigationController?.pushViewController(detail, animated: true)
        })

    }
}

enum EMain: Int {
    case topSaller
    case category
    
}

class MainSlideData {
    var id: String?
    var img: UIImage?
    var imageURL: String?
    var categoryID: Int?
    var categoryName: String?
}

class MainDataGroup {
    var type: EMain = .topSaller
    var category: CategoryDTO = CategoryDTO()
    
}



