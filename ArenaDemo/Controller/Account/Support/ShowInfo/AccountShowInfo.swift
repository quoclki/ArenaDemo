//
//  AccountStoreVCtrl.swift
//  App Ban Hang
//
//  Created by Lu Kien Quoc on 8/9/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI
import WebKit

class AccountShowInfo: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    
    // MARK: - Private properties
    private var dto: PageDTO = PageDTO()
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ dto: PageDTO) {
        super.init()
        self.dto = dto
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: dto.title?.rendered?.uppercased() ?? "")
        addViewToLeftBarItem(createBackButton())
        configWebView()
    }
    
    func configWebView() {
        vSafe.clipsToBounds = true
        vSafe.cleanSubViews()
        
        let web = WKWebView()
        web.frame = vSafe.bounds
        web.autoresizingMask = vSafe.autoresizingMask

        let urlString = SEBase.apiURL.combinePath(self.dto.slug ?? "")
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            web.load(request)
        }

        web.backgroundColor = .white
        web.navigationDelegate = self
        vSafe.addSubview(web)
        
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

extension AccountShowInfo: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        vSafe.showLoadingView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        vSafe.showLoadingView(false)
        
        let heightTop: CGFloat = 150
        let vTop = UIView()
        vTop.frame = CGRect(0, 0, webView.width, heightTop)
        vTop.backgroundColor = .white
        webView.scrollView.delegate = self
        webView.scrollView.addSubview(vTop)
        webView.scrollView.contentInset.top = -heightTop
        
        let heightBottom: CGFloat = 840
//        let vBottom = UIView()
//        vBottom.frame = CGRect(0, webView.scrollView.contentSize.height - heightBottom, webView.width, heightBottom)
//        vBottom.backgroundColor = .blue
//        webView.scrollView.addSubview(vBottom)
        webView.scrollView.contentInset.bottom = -heightBottom
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
}





