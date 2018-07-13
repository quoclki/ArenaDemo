//
//  GeneralData.swift
//  ArenaDemo
//
//  Created by Lu Kien Quoc on 7/13/18.
//  Copyright © 2018 Arena Design VN. All rights reserved.
//

import Foundation
import ArenaDemoAPI

class SettingConfig {
    
    static var shared: SettingConfig = SettingConfig()
    
    var lstGeneralSetting: [GeneralDTO] = [] {
        didSet {
            setupData()
        }
    }
    
    var address: GeneralDTO = GeneralDTO()
    var address2: GeneralDTO = GeneralDTO()
    var city: GeneralDTO = GeneralDTO()
    var country: GeneralDTO = GeneralDTO()
    var currency: GeneralDTO = GeneralDTO()
    var currencyPos: GeneralDTO = GeneralDTO()
    var thousandSeparator: GeneralDTO = GeneralDTO()
    var deciamlSeparator: GeneralDTO = GeneralDTO()
    var numOfDecimals: GeneralDTO = GeneralDTO()
    
    func setupData() {
        address = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_store_address.rawValue }) ?? GeneralDTO()
        address2 = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_store_address_2.rawValue }) ?? GeneralDTO()
        city = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_store_city.rawValue }) ?? GeneralDTO()
        country = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_default_country.rawValue }) ?? GeneralDTO()
        currency = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_currency.rawValue }) ?? GeneralDTO()
        if let value = currency.value, let code = SettingConfig.shared.currency.options[value]?.split(" ").last?.htmlAttribute?.string, code.count > 2 {
            currency.symbol = String(code[1..<code.count - 1])
        }

        currencyPos = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_currency_pos.rawValue }) ?? GeneralDTO()
        thousandSeparator = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_price_thousand_sep.rawValue }) ?? GeneralDTO()
        deciamlSeparator = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_price_decimal_sep.rawValue }) ?? GeneralDTO()
        numOfDecimals = lstGeneralSetting.first(where: { $0.id == ESettingID.woocommerce_price_num_decimals.rawValue }) ?? GeneralDTO()

    }
    
}

enum ESettingID: String {
    case woocommerce_store_address = "woocommerce_store_address"
    case woocommerce_store_address_2 = "woocommerce_store_address_2"
    case woocommerce_store_city = "woocommerce_store_city"
    case woocommerce_default_country = "woocommerce_default_country"
    case woocommerce_store_postcode = "woocommerce_store_postcode"
    case woocommerce_allowed_countries = "woocommerce_allowed_countries"
    case woocommerce_all_except_countries = "woocommerce_all_except_countries"
    case woocommerce_specific_allowed_countries = "woocommerce_specific_allowed_countries"
    case woocommerce_ship_to_countries = "woocommerce_ship_to_countries"
    case woocommerce_specific_ship_to_countries = "woocommerce_specific_ship_to_countries"
    case woocommerce_default_customer_address = "woocommerce_default_customer_address"
    case woocommerce_calc_taxes = "woocommerce_calc_taxes"
    case woocommerce_enable_coupons = "woocommerce_enable_coupons"
    case woocommerce_calc_discounts_sequentially = "woocommerce_calc_discounts_sequentially"
    case woocommerce_currency = "woocommerce_currency"
    case woocommerce_currency_pos = "woocommerce_currency_pos"
    case woocommerce_price_thousand_sep = "woocommerce_price_thousand_sep"
    case woocommerce_price_decimal_sep = "woocommerce_price_decimal_sep"
    case woocommerce_price_num_decimals = "woocommerce_price_num_decimals"
}

enum ECurrencyPosOption: String {
    case left = "left"
    case right = "right"
    case left_space = "left_space"
    case right_space = "right_space"
}
