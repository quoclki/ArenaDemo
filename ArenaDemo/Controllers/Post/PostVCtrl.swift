//
//  PostVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/12/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class PostVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var scvCategory: UIScrollView!
    @IBOutlet weak var vMark: UIView!
    @IBOutlet weak var tbvPost: UITableView!
    
    // MARK: - Private properties
    private var lstPostCategory: [PostCategoryDTO] = []
    private var lstPost: [PostDTO] = []
    private var cellID = "postCellID"
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ lstPostCategory: [PostCategoryDTO]) {
        super.init()
        self.lstPostCategory = lstPostCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Posts"
        configTableView()
        configScrollViewCategory()
    }
    
    func configTableView() {
        tbvPost.register(UINib(nibName: String(describing: TbvPostCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        tbvPost.dataSource = self
        tbvPost.delegate = self
        
    }

    func configScrollViewCategory() {
        vMark.originX = -vMark.width
        for (index, element) in lstPostCategory.enumerated() {
            let btn = UIButton(type: .system)
            btn.frame = CGRect(CGFloat(index) * vMark.width, 0, vMark.width, scvCategory.height)
            btn.setTitle(element.name, for: .normal)
            btn.accessibilityValue = element.id?.toString()
            btn.touchUpInside(block: btnCategory_Touched)
            scvCategory.addSubview(btn)
            scvCategory.contentSize.width = btn.frame.maxX
            
            if index == 0 {
                btn.sendActions(for: .touchUpInside)
            }
        }
        
    }
    
    
    override func configUIViewWillAppear() {
        super.configUIViewWillAppear()
        
    }
    
    // MARK: - Event Listerner
    override func eventListener() {
        super.eventListener()
        
    }
    
    // MARK: - Event Handler
    func btnCategory_Touched(sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.vMark.originX = sender.originX
    
            if sender.frame.maxX - self.scvCategory.contentOffset.x > self.scvCategory.width {
                self.scvCategory.contentOffset.x = sender.frame.maxX - self.scvCategory.width
                return
            }
            
            if sender.originX < self.scvCategory.contentOffset.x {
                self.scvCategory.contentOffset.x = sender.originX
            }
        }
        
        getPost(id: Int(sender.accessibilityValue ?? ""))
        
    }
    
    func getPost(id: Int?) {
        lstPost.removeAll()
        tbvPost.reloadData()
        
        let request = GetPostRequest(page: 1)
        request.categories = id
        
        SEPost.getListPost(request, animation: {
            self.showLoadingView($0)
            
        }) { (response) in
            guard let lst = response?.lstPost else { return }
            self.lstPost = lst
            self.tbvPost.reloadData()
            
        }
        
        
    }
    
    // MARK: - Func
    override func loadData() {
        super.loadData()
        
    }
}

extension PostVCtrl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lstPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TbvPostCell
        let item = lstPost[indexPath.row]
        cell.updateCell(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = lstPost[indexPath.row]
        let post = PostDetailVCtrl(item)
        navigationController?.pushViewController(post, animated: true)
    }
    
}
