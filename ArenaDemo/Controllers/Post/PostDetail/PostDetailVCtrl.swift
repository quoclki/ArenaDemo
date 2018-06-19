//
//  PostDetailVCtrl.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/14/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import UIKit
import ArenaDemoAPI

class PostDetailVCtrl: BaseVCtrl {

    // MARK: - Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txvDetail: UITextView!
    @IBOutlet weak var lblAuthor: UILabel!
    
    // MARK: - Private properties
    private var postDTO: PostDTO = PostDTO()
    private var lstAuthor: [UserDTO] = []
    
    // MARK: - Properties
    
    // MARK: - Init
    init(_ postDTO: PostDTO) {
        super.init()
        self.postDTO = postDTO
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController func
    
    // MARK: - Layout UI
    override func configUI() {
        super.configUI()
        title = "Post Detail"
        lblTitle.text = postDTO.title?.rendered
        txvDetail.attributedText = postDTO.content?.rendered?.htmlAttribute
        txvDetail.isEditable = false
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
        getAuthor()
    }
    
    func getAuthor() {
        lblAuthor.text = ""
        guard let lstAuthorLink = postDTO._links?.author.map({ $0.href ?? "" }), !lstAuthorLink.isEmpty else { return }
        lstAuthor.removeAll()
        lstAuthorLink.forEach { (authorLink) in
            let request = GetUserRequest()
            request.special_link = authorLink
            
            SEUser.getListUser(request, completed: { (response) in
                if !self.checkResponse(response) {
                    return
                }

                if let user = response.lstUser.first {
                    self.lstAuthor.append(user)
                }
                
                if self.lstAuthor.count == lstAuthorLink.count {
                    self.lblAuthor.text = self.lstAuthor.map({ $0.name ?? "" }).joined(separator: ", ")
                }
            })
            
            
        }
        
  
        
    }
}
