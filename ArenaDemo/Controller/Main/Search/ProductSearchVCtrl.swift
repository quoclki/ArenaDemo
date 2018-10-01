//
//  ProductSearchVCtrl.swift
//  App Ban Hang
//
//  Created by Lu Kien Quoc on 7/27/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class ProductSearchVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var clvSearch: UICollectionView!
    
    // MARK: - Private properties
    private var searchText: String? = nil {
        didSet {
            if searchText == nil {
                return
            }
            
            handleSearch()
        }
    }
    
    private var lstItem: [ProductDTO] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ text: String? = nil) {
        super.init()
        self.accessibilityValue = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        createNavigationBar(vSafe, searchBar: searchBar)
        configCollectionView()
        configSearchBar()
    }
    
    func configSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        let text = self.accessibilityValue
        searchBar.text = text
        searchText = text
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
    
    func handleSearch() {
        let request = GetProductRequest(page: 1)
        request.search = searchText
        
        task?.cancel()
        task = SEProduct.getListProduct(request, animation: {
            self.view.showLoadingView($0, frameLoading: self.vSafe.frame)
            
        }, completed: { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            self.lblResult.text = "\( response.lstProduct.count.toString() ) Kết Quả Cho Từ Khoá \"\( self.searchText ?? "" )\""
            self.lstItem = response.lstProduct
            self.clvSearch.reloadData()
            
        })
    }
}

extension ProductSearchVCtrl: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchText = searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProductSearchVCtrl: UICollectionViewDataSource, UICollectionViewDelegate {
    private var cellID: String {
        return String(describing: ClvProductCell.self)
    }
    
    private var backgroundColor: UIColor {
        return UIColor(hexString: "F1F2F2")
    }
    
    func configCollectionView() {
        clvSearch.backgroundColor = backgroundColor
        clvSearch.register(UINib(nibName: cellID, bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: cellID)
        clvSearch.dataSource = self
        clvSearch.delegate = self
        
        if let layout = clvSearch.collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 15
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
            layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            layout.itemSize = CGSize((Ratio.width -  padding * 3) / 2, 265 * Ratio.ratioWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = lstItem[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ClvProductCell
        cell.updateCell(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = lstItem[indexPath.row]
        pushProductVCtrl(item){
            collectionView.showLoadingView($0)
        }
    }
    
}


