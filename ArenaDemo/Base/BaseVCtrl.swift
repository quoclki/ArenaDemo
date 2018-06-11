//
//  BaseVCtrl.swift
//  199k
//
//  Created by Lu Kien Quoc on 6/3/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import Foundation
import UIKit

class BaseVCtrl: UIViewController {
    
    // MARK: - Outlet
    
    // MARK: - Private properties
    
    // MARK: - Properties
    var isCreateBack = true {
        didSet {
            setupNavigation()
        }
    }

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUIViewWillAppear()
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        setupNavigation()
    }
    
    func setupNavigation() {
        let interactive = navigationController?.interactivePopGestureRecognizer
        interactive?.delegate = nil
        if let vctrl = navigationController?.topViewController as? BaseVCtrl {
            interactive?.isEnabled = vctrl.isCreateBack
        }
        
    }

    
    // MARK: - Layout UI
    func configUI() {
    }
    
    func configUIViewWillAppear() {
        
    }
    
    
    /// add a custom view to left item on navigation bar
    public func addViewToLeftBarItem(view: UIView, isTranslate: Bool = true) {
        if isTranslate {
            view.findAndReplaceText()
        }
        view.backgroundColor = navigationController?.navigationBar.barTintColor
        let barItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = barItem
        isCreateBack = false
    }
    
    /// add a custom view to right item on navigation bar
    public func addViewToRightBarItem(view: UIView) {
        view.findAndReplaceText()
        view.backgroundColor = navigationController?.navigationBar.barTintColor
        let barItem = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem = barItem
    }

    // MARK: - Event Listerner
    func eventListener() {
        
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
    func loadData() {
        
    }
    
    /// show loading
    func showLoadingView(_ isShow: Bool = true, frameLoading: CGRect = CGRect.zero, loadingBgColor color: UIColor = UIColor(hexString: "000000", a: 0.1), valueOfLoadingView value: String = "viewForLoading", lockLeftBarItem: Bool = true) {
        //lock navigation
        navigationController?.topViewController?.navigationItem.rightBarButtonItem?.customView?.isUserInteractionEnabled = !isShow
        if lockLeftBarItem {
            navigationController?.navigationBar.isUserInteractionEnabled = !isShow
            navigationController?.topViewController?.navigationItem.leftBarButtonItem?.customView?.isUserInteractionEnabled = !isShow
            
        }
        
        if !isShow {
            if let viewLoading = self.view.subviews.firstOrDefault({ $0.accessibilityValue == value }) {
                viewLoading.removeFromSuperview()
            }
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

        func getVCtrlInNavigation<T: UIViewController>(_ type: T.Type) -> T? {
        return navigationController?.viewControllers.firstOrDefault{$0 is T} as? T
    }

    
    
}

