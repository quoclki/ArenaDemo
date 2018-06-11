//
//  SlideVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/11/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class SlideVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var imvPhoto: UIImageView!
    
    // MARK: - Private properties
    private var image: Images = Images()
    
    // MARK: - Properties
    
    // MARK: - Init
    init(image: Images) {
        super.init()
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        ImageStore.shared.setImg(toImageView: imvPhoto, imgURL: image.src)

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
