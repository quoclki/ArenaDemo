//
//  ProductPhotoVCtrl.swift
//  App Ban Hang
//
//  Created by Lu Kien Quoc on 7/30/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class ProductPhotoVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var vDisable: UIView!
    @IBOutlet weak var clvPhoto: UICollectionView!
    
    // MARK: - Private properties
    private var lstImage: [Images] = []
    private var selectedImage: Images?

    // MARK: - Properties
    
    // MARK: - Init
    init(_ lstImage: [Images], selectedImage: Images? = nil) {
        super.init()
        self.lstImage = lstImage
        self.selectedImage = selectedImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        configCollectionView()
        showViewDisable(true)
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        if let selectedImage = self.selectedImage {
            guard let index = self.lstImage.index(where: { $0.id == selectedImage.id }) else {
                return
            }
            self.clvPhoto.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        }

    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        vDisable.addGestureRecognizer(tap)
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    @objc func handleTap(_ tapGesture: UITapGestureRecognizer) {
        showViewDisable(false) {
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    
    func showViewDisable(_ isShow: Bool, completed: (() -> ())? = nil) {
        vDisable.alpha = isShow ? 0 : 1
        UIView.animate(withDuration: 0.3, animations: {
            self.vDisable.alpha = isShow ? 1 : 0

        }) { (finish) in
            completed?()
        }
    }
    
}

extension ProductPhotoVCtrl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var cellID: String {
        return String(describing: ClvPhotoCell.self)
    }
    
    func configCollectionView() {
        clvPhoto.backgroundColor = .clear
        clvPhoto.register(UINib(nibName: cellID, bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 1
        flowLayout.spacingMode = .fixed(spacing: 15)
        flowLayout.itemSize = CGSize(300 * Ratio.ratioWidth, 456 * Ratio.ratioWidth)

        clvPhoto.collectionViewLayout = flowLayout
        clvPhoto.dataSource = self
        clvPhoto.delegate = self
        clvPhoto.showsHorizontalScrollIndicator = false
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = lstImage[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvPhotoCell
        cell.updateCell(item)
        return cell
    }
    
}
