//
//  Base.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 6/4/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import Foundation
import ArenaDemoAPI

class Base {
    static var container: ContainerVCtrl!
}

public extension BaseRequest {
    convenience init(page: Int) {
        self.init()
        self.page = page
        self.per_page = 50
        
    }
}

extension BaseVCtrl {
    func checkResponse<T: BaseResponse>(_ response: T) -> Bool {
        if !response.success {
            _ = showWarningAlert(message: response.message ?? "")
        }
        
        return response.success
    }
    
}
