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
    
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    func convertToDateString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = .autoupdatingCurrent
        var date: Date?
        date = dateFormatter.date(from: String(self.prefix(19)))
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "dd MMM, HH:mm"
        let convertedDateString = dateStringFormatter.string(from: date ?? Date())
        return convertedDateString
    }
}
