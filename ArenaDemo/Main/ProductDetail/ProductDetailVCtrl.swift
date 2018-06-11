//
//  ProductDetailVCtrl.swift
//  App199k
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
    
    // MARK: - Private properties
    fileprivate var product: ProductDTO = ProductDTO()
    
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
        lblPrice.text = "Price: \( product.price?.toString() ?? "" )"

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
