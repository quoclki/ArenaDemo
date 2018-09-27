//
//  BaseVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/3/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import Foundation
import UIKit
import ArenaDemoAPI
import CustomControl
import OAuthSwift

class BaseVCtrl: UIViewController {
    
    // MARK: - Outlet
    
    // MARK: - Private properties

    // MARK: - Properties
    var task: OAuthSwiftRequestHandle?
    var vFocusInput: UIView?
    var vBar: UIView!
    var vSetSafeArea: UIView!

    // MARK: - Init
    public init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadData()
        eventListener()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUIViewWillAppear()
    }
    
    // MARK: - Layout UI
    func configUI() {
    }
    
    func configUIViewWillAppear() {
        
    }
    
    func createNavigationBar(_ vSafe: UIView, title: String? = nil, searchBar: UISearchBar? = nil) {
        self.vSetSafeArea = vSafe
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let barHeight: CGFloat = 50
        let v = UIView()
        v.backgroundColor = Base.baseColor
        v.frame = CGRect(0, 0, UIScreen.main.bounds.width, statusBarHeight + barHeight)
        
        if let title = title {
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
            label.sizeToFit()
            label.center = CGPoint(v.center.x, statusBarHeight + barHeight / 2)
            label.textColor = Base.titleTintColor
            v.addSubview(label)
        }
        
        if let searchBar = searchBar {
            searchBar.backgroundImage = UIImage()
            searchBar.enablesReturnKeyAutomatically = true
            searchBar.width = v.width * 0.95
            searchBar.center = CGPoint(v.center.x, statusBarHeight + barHeight / 2)
            searchBar.tintColor = .white
            if let textField = searchBar.value(forKey: "searchField") as? UITextField, let backgroundView = textField.subviews.first {
                backgroundView.layer.cornerRadius = 19
                backgroundView.clipsToBounds = true
                backgroundView.height = 20
                textField.tintColor = .black
            }
            v.addSubview(searchBar)
        }
        
        vBar = v
        
        // setup vSafe
        let value = vBar.height - vSafe.originY
        vSafe.originY = vBar.height
        vSafe.height = vSafe.height - value
        
        self.view.addSubview(vBar)
        
    }
    
    func createBackButton(_ width: CGFloat = 60, handleBack: ((UIButton) -> Void)? = nil) -> UIButton {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let btn = UIButton(type: .system)
        btn.frame = CGRect(0, statusBarHeight, width, vBar.height - statusBarHeight)
        btn.imageEdgeInsets.left = 15
        btn.setImage(UIImage(named: "icon-back", in: Bundle(for: Base.self), compatibleWith: nil), for: .normal)
        btn.tintColor = Base.titleTintColor
        btn.backgroundColor = Base.baseColor
        btn.contentHorizontalAlignment = .left
        btn.touchUpInside { (sender) in
            if let handleBack = handleBack {
                handleBack(sender)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        return btn
    }
    
    /// add a custom view to left item on navigation bar
    public func addViewToLeftBarItem(_ view: UIView) {
        guard let vBar = self.vBar else {
            return
        }
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        view.backgroundColor = vBar.backgroundColor
        view.origin = CGPoint(0, statusBarHeight)
        vBar.addSubview(view)
        
//        isCreateBack = false
    }

    /// add a custom view to right item on navigation bar
    public func addViewToRightBarItem(_ view: UIView) {
        guard let vBar = self.vBar else {
            return
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        view.backgroundColor = vBar.backgroundColor
        view.origin = CGPoint(vBar.width - view.width, statusBarHeight)
        vBar.addSubview(view)

//        self.navigationItem.rightBarButtonItem = barItem
    }
    
    // MARK: - Event Listerner
    func eventListener() {
        
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
    func loadData() {
        
    }
    
    /// show loading
    func showLoadingView(_ isShow: Bool = true, frameLoading: CGRect = CGRect.zero, loadingBgColor color: UIColor = UIColor(hexString: "000000", a: 0.1), valueOfLoadingView value: String = "viewForLoading") {
        
        if !isShow {
            self.view.subviews.first(where: { $0.accessibilityValue == value })?.removeFromSuperview()
            return
        }
        
        let viewLoading = UIView()
        viewLoading.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewLoading.frame = frameLoading == CGRect.zero ? self.view.bounds : frameLoading
        viewLoading.backgroundColor = color
        viewLoading.accessibilityValue = value
        
        let vLoadingSmall = UIView()
        vLoadingSmall.frame.size = CGSize(width: 40, height: 40)
        vLoadingSmall.backgroundColor = UIColor(hexString: "000000", a: 0.3)
        vLoadingSmall.center = CGPoint(x: viewLoading.width / 2, y: viewLoading.height / 2)
        vLoadingSmall.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        vLoadingSmall.cornerRadius = 4
        
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.autoresizingMask = vLoadingSmall.autoresizingMask
        indicator.center = CGPoint(x: vLoadingSmall.width / 2, y: vLoadingSmall.width / 2)
        
        vLoadingSmall.addSubview(indicator)
        viewLoading.addSubview(vLoadingSmall)
        
        self.view.addSubview(viewLoading)
        self.view.bringSubview(toFront: viewLoading)
    }
    
    /// Get Navigation Child ViewController
    func getVCtrlInNavigation<T: UIViewController>(_ type: T.Type) -> T? {
        return navigationController?.viewControllers.firstOrDefault{$0 is T} as? T
    }
    
    /// get Category All
    func getAllCategory() -> CategoryDTO {
        let all = CategoryDTO()
        all.name = "All"
        return all
    }

    /// Auth Account
    func getAuthDTO(_ username: String?, password: String?, completed: @escaping ((AuthDTO) -> Void)) {
        let request = GetAuthRequest()
        request.username = username
        request.password = password
        
        task = SEAuth.authentication(request, animation: {
            self.showLoadingView($0, frameLoading: self.vSetSafeArea.frame)
            self.vBar.isUserInteractionEnabled = !$0
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            guard let dto = response.authDTO else {
                _ = self.showWarningAlert(title: "Cảnh báo", message: "Không thể xác thực!")
                return
            }
            
            completed(dto)
        })
        
    }
    
    func getCustomerDTO(_ email: String?, completed: @escaping ((CustomerDTO) -> Void)) {
        let request = GetCustomerRequest(page: 1)
        request.email = email
        request.role = ECustomerRole.all.rawValue
        
        task = SECustomer.getList(request, animation: {
            self.showLoadingView($0, frameLoading: self.vSetSafeArea.frame)
            self.vBar.isUserInteractionEnabled = !$0

        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            guard let dto = response.lstCustomer.first else {
                _ = self.showWarningAlert(title: "Cảnh báo", message: "Không tốn tại thông tin user!")
                return
            }
            
            completed(dto)
            
        })
        
    }

    /// Did select product page
    func pushProductVCtrl(_ dto: ProductDTO) {
        func push() {
            let detail = ProductDetailVCtrl(dto)
            self.navigationController?.pushViewController(detail, animated: true)
        }
        
        if dto.descriptionAttributed != nil {
            push()
            return
        }
        
        self.showLoadingView(frameLoading: self.vSetSafeArea.frame)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .justified
        
        // 345 is lblDescrition width of iPhone8 size
        // 45 is ratio of lblDescrition of iPhone8 size
        let ratio = (Ratio.width - 30) * 44 / 345
        
        Helper.backgroundWorker({
            let attributed = dto.description?.htmlImageCorrector(ratio).htmlAttribute
            attributed?.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.paragraphStyle: paragraph], range: NSMakeRange(0, attributed?.length ?? 0))
            dto.descriptionAttributed = attributed

        }) {
            self.showLoadingView(false)
            push()
        }
    }
}

/// For Keyboard Only
extension BaseVCtrl: UIScrollViewDelegate {
    func handleFocusInputView(_ focusView: UIView) {
        self.vFocusInput = focusView
    }
    
    func handleKeyboard(willShow notify: NSNotification, scv: UIScrollView) {
        guard let keyboardFrame: NSValue = notify.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        
        guard let vFocus = self.vFocusInput else {
            return
        }
        
        guard let frame = vFocus.superview?.convert(vFocus.frame, to: self.view) else {
            return
        }
        
        if frame.maxY > keyboardRectangle.origin.y {
            let cal = frame.maxY - keyboardRectangle.origin.y + 10
            scv.setContentOffset(CGPoint(0, scv.contentOffset.y + cal), animated: true)
        }
        
    }
    
    func handleKeyboard(willHide notify: NSNotification, scv: UIScrollView) {
        let totalHeightScroll = scv.contentOffset.y + scv.height
        let heightContentSize = max(scv.contentSize.height, scv.height)
        if totalHeightScroll > heightContentSize {
            scv.setContentOffset(CGPoint(0, scv.contentOffset.y - (totalHeightScroll - heightContentSize)), animated: true)
        }
    }
    
}

