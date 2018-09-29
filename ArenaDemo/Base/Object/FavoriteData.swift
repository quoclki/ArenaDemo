//
//  FavoriteData.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 9/29/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import Foundation
import ArenaDemoAPI

class FavoriteData {
    
    static var shared = FavoriteData()
    
    var lstItem: [Int] {
        get {
            return UserDefaults.standard.value(forKey: EUserDefaultKey.favoriteData.rawValue) as? [Int] ?? []
        }
    }
    
    func handleFavoriteList(_ id: Int?, isSave: Bool = false) {
        guard let id = id else {
            return
        }
        
        var lst = self.lstItem
        if isSave {
            lst.append(id)
        } else {
            _ = lst.removeObject(id)
        }
        
        UserDefaults.standard.set(lst, forKey: EUserDefaultKey.favoriteData.rawValue)
        
    }
    
    func checkInList(_ id: Int?) -> Bool {
        guard let id = id else {
            return false
        }
        
        return lstItem.contains(id)
    }
        
}
