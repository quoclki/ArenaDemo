//
//  MainVCtrl.swift
//  199k
//
//  Created by Lu Kien Quoc on 6/3/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import CustomControl
import ArenaDemoAPI

class MainVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var tbvCategory: UITableView!
    
    // MARK: - Private properties
    fileprivate var lstCategory: [CategoryDTO] = []
    fileprivate var categoryCellID = "categoryID"
    
    // MARK: - Properties
    var refControl = UIRefreshControl()
    
    // MARK: - Init
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Categories"
        navigationController?.navigationBar.isTranslucent = false
        configTableView()
        
    }
    
    func configTableView() {
        tbvCategory.register(UINib(nibName: String(describing: TbvCategoryCell.self), bundle: nil), forCellReuseIdentifier: categoryCellID)
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
        let request = GetCategoryRequest(page: 1)

        SEProduct.getListCategory(request, animation: {
            self.showLoadingView($0)
            $0 ? self.refControl.beginRefreshing() : self.refControl.endRefreshing()
        }) { (reponse) in
            if let lst = reponse?.lstCategory {
                self.lstCategory = lst
                self.tbvCategory.reloadData()
            }


        }
        
    }
    
    @objc func handleRefresh(_ refControl: UIRefreshControl) {
        let request = GetCategoryRequest(page: 1)
        
        SEProduct.getListCategory(request, animation: {
            $0 ? self.refControl.beginRefreshing() : self.refControl.endRefreshing()
        }) { (reponse) in
            if let lst = reponse?.lstCategory {
                self.lstCategory = lst
                self.tbvCategory.reloadData()
            }
        }
    }
    
    
}

extension MainVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID) as! TbvCategoryCell
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
        }) { (reponse) in
            if let lst = reponse?.lstProduct {
                let product = ProductVCtrl(lstProduct: lst)
                self.navigationController?.pushViewController(product, animated: true)
            }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}



