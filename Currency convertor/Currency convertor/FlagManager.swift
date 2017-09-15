//
//  FlagManager.swift
//  Currency convertor
//
//  Created by Кирилл Володин on 15.09.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class FlagManager {
    
    static let dictionary: Dictionary<String, UIImage> = [
        "EUR": UIImage(named: "EU")!, 
        "AUD": UIImage(named: "AU")!,
        "BGN": UIImage(named: "BG")!,
        "BRL": UIImage(named: "BR")!,
        "CAD": UIImage(named: "CA")!,
        "CHF": UIImage(named: "CH")!,
        "CNY": UIImage(named: "CN")!,
        "CZK": UIImage(named: "CZ")!,
        "DKK": UIImage(named: "DK")!,
        "GBP": UIImage(named: "GB")!,
        "HKD": UIImage(named: "HK")!,
        "HRK": UIImage(named: "HR")!,
        "HUF": UIImage(named: "HU")!,
        "IDR": UIImage(named: "ID")!,
        "ILS": UIImage(named: "IL")!,
        "INR": UIImage(named: "IN")!,
        "JPY": UIImage(named: "JP")!,
        "KRW": UIImage(named: "KR")!,
        "MXN": UIImage(named: "MX")!,
        "MYR": UIImage(named: "MY")!,
        "NOK": UIImage(named: "NO")!,
        "NZD": UIImage(named: "NZ")!,
        "PHP": UIImage(named: "PH")!,
        "PLN": UIImage(named: "PL")!,
        "RON": UIImage(named: "RO")!,
        "RUB": UIImage(named: "RU")!,
        "SEK": UIImage(named: "SE")!,
        "SGD": UIImage(named: "SG")!,
        "THB": UIImage(named: "TH")!,
        "TRY": UIImage(named: "TR")!,
        "USD": UIImage(named: "US")!,
        "ZAR": UIImage(named: "ZA")!,
    ]
    
    class func getFlagForCurrency(_ currency: String) -> UIImage {
        if let image = dictionary[currency] {
            return image
        }
        return UIImage()
    }
    
}
