//
//  MainSlideVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 10/3/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import CustomControl
import ArenaDemoAPI

class MainSlideVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var imv: UIImageView!
    @IBOutlet weak var btnSelect: UIButton!
    
    // MARK: - Private properties
    var slideItem: MainSlideData!
    var handleSelect: ((CategoryDTO) -> ())? = nil
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ slideItem: MainSlideData) {
        super.init()
        self.slideItem = slideItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
//        ImageStore.shared.setImg(toImageView: self.imv, imgURL: self.slideItem.imageURL)
        self.imv.image = self.slideItem.img?.resize(newWidth: Ratio.width)
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        btnSelect.touchUpInside(block: btnSelect_Touched)
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    func btnSelect_Touched(sender: UIButton) {
        let item = CategoryDTO()
        item.id = slideItem.categoryID
        item.name = slideItem.categoryName
        handleSelect?(item)

    }

}
