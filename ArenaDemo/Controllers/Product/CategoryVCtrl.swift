//
//  MainVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/3/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import CustomControl
import ArenaDemoAPI

class CategoryVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var tbvCategory: UITableView!
    
    // MARK: - Private properties
    fileprivate var lstCategory: [CategoryDTO] = []
    fileprivate var cellID = "categoryID"
    
    // MARK: - Properties
    var refControl = UIRefreshControl()
    
    // MARK: - Init
    init(_ lstCategory: [CategoryDTO]) {
        super.init()
        self.lstCategory = lstCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Categories"
        configTableView()
        
    }
    
    func configTableView() {
        tbvCategory.register(UINib(nibName: String(describing: TbvCategoryCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvCategory.dataSource = self
        tbvCategory.delegate = self
    }
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        
        refControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tbvCategory.addSubview(refControl)
        
    }
    
    // MARK: - Event Handler
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
    
    @objc func handleRefresh(_ refControl: UIRefreshControl) {
        let request = GetCategoryRequest(page: 1)
        
        SEProduct.getListCategory(request, animation: {
            $0 ? self.refControl.beginRefreshing() : self.refControl.endRefreshing()
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }
            
            let lst = response.lstCategory
            self.lstCategory = lst
            
            self.lstCategory.insert(self.getAllCategory(), at: 0)
            self.tbvCategory.reloadData()
        }
    }
        
}

extension CategoryVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvCategoryCell
        let item = lstCategory[indexPath.row]
        cell.updateCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = lstCategory[indexPath.row]
        let request = GetProductRequest(page: 1)
        request.category = item.id?.toString()

        SEProduct.getListProduct(request, animation: {
            self.showLoadingView($0)
        }) { (response) in
            if !self.checkResponse(response) {
                return
            }

            let lst = response.lstProduct
            let product = ProductVCtrl(lstProduct: lst)
            self.navigationController?.pushViewController(product, animated: true)
            
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}



