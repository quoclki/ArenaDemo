//
//  Base.swift
//  App199k
//
//  Created by Lu Kien Quoc on 6/4/18.
//  Copyright © 2018 Newstead Technologies VN. All rights reserved.
//

import Foundation
import ArenaDemoAPI

class Base {
    
}

public extension BaseRequest {
    convenience init(page: Int) {
        self.init()
        self.page = page
        self.per_page = 50
        
    }
}
