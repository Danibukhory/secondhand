//
//  String+Extensions.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import Foundation

extension String {
    func isValidPassword(_ text: String) -> Bool {
        if text.count >= 5 {
            return true
        } else {
            return false
        }
    }
}

extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
}
