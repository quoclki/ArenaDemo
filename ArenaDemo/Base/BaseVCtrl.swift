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
    
    // MARK: - Layout UI
    func configUI() {
    }
    
    func configUIViewWillAppear() {
        
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

    
    
    
}

