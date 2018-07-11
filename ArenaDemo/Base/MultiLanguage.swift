//
//  MultiLanguage.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/10/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import Foundation

class MultiLanguage {
    static var shared = MultiLanguage()
    
    var dicLanguage: [String: String] = [:]
//    var lstLanguage: [LanguageDTO] = []
//    var languageID: String {
//        return (UserDefaults.standard.value(forKey: EUserDefaultKey.currentLanguage.rawValue) as? String) ?? ""
//    }
    
//    var currentLanguage: LanguageDTO? {
//        return lstLanguage.firstOrDefault({$0.id == self.languageID})
//    }
    
//    var currentLocale: String {
//        return currentLanguage?.locale ?? "en"
//    }
    
    func setUpLanguageDictionary() {
//        dicLanguage.updateValue("Trang chủ", forKey: "home")
//        dicLanguage.updateValue("Danh mục", forKey: "category")
//        dicLanguage.updateValue("Giỏ", forKey: "cart")
//        dicLanguage.updateValue("Tài khoản", forKey: "account")
//        dicLanguage.updateValue("Tìm kiếm", forKey: "search")
//        dicLanguage.updateValue("Sản phẩm bán chạy", forKey: "top saller")
//        dicLanguage.updateValue("Xem thêm", forKey: "view more")
//        dicLanguage.updateValue("Giỏ hàng của tôi", forKey: "my cart")
//        dicLanguage.updateValue("Đơn Hàng Của Tôi", forKey: "my order")
//        dicLanguage.updateValue("Danh Sách Ưa Thích", forKey: "favourite list")
//        dicLanguage.updateValue("Chính Sách Mua Hàng", forKey: "order condition")
//        dicLanguage.updateValue("Hệ Thống Cửa Hàng", forKey: "store system")
//        dicLanguage.updateValue("Thông Tin Liên Hệ", forKey: "contact info")
//        dicLanguage.updateValue("ĐĂNG NHẬP", forKey: "sign up")
//        dicLanguage.updateValue("ĐĂNG KÍ", forKey: "sign in")
//        dicLanguage.updateValue("Mật khẩu", forKey: "password")


    }
}

public extension String {
    
    //return language
    var languageValue: String {
        let str = self.lowercased().trim
        if MultiLanguage.shared.dicLanguage.isEmpty || str.isEmpty { return self }
        return MultiLanguage.shared.dicLanguage[str] ?? self
    }
    
    var translate: String {
        var firstString: String = ""
        var lastSpecialChar: String = self
        
        // loop in reversed string array
        for (index, char) in unicodeScalars.reversed().enumerated() {
            let str = String(char)
            
            // find first non special character from reversed string
            if str.isAlphabet || str.isNumber {
                // string to be translated
                firstString = String(self[0...count - 1 - index])
                
                // special character
                lastSpecialChar = index > 0 ? String(self[count - index...count - 1]) : ""
                break
            }
        }
        
        return firstString.languageValue + lastSpecialChar.languageValue
    }
    
    func toCurrencyString() -> String {
        let number = self.toDouble()
        return number.toCurrencyString()
    }

}

extension Double {
    func toCurrencyString() -> String {
        let formater = NumberFormatter()
        formater.locale = Locale(identifier: "vi_VN")
        formater.numberStyle = .currencyISOCode
        return formater.string(from: NSNumber(value: self)) ?? ""
    }
    
}