//
//  ContinueOrderVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/18/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit

class ContinueOrderVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    // MARK: - Private properties
    private var _isCart: Bool = false
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ isCart: Bool = false) {
        super.init()
        self._isCart = isCart
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, title: _isCart ? "GIỎ HÀNG" : "ĐẶT HÀNG THÀNH CÔNG")
        lblDes.text = _isCart ? "HIỆN TẠI GIỎ HÀNG CỦA BẠN ĐANG TRỐNG" : "ĐƠN HÀNG ĐÃ ĐẶT THÀNH CÔNG"
        imv.image = UIImage(named: _isCart ? "img-Cart" : "img-Like", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnContinue.touchUpInside(block: btnContinue_Touched)
    }
    
    // MARK: - Event Handler
    func btnContinue_Touched(sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        Base.container.tab = .home
        
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}
