//
//  Int+Extension.swift
//  SecondHand
//
//  Created by Bagas Ilham on 30/06/22.
//

import Foundation

extension Int {
    func convertToCurrency() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currencyAccounting
        currencyFormatter.locale = Locale(identifier: "id_ID")
        if let currencyString = currencyFormatter.string(from: NSNumber(integerLiteral: self)) {
            return currencyString
        } else {
            return ""
        }
    }
}
