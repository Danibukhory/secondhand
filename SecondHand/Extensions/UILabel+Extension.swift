//
//  UILabel+Extension.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

enum labelWeight: String {
    case light = "Poppins-Light"
    case medium = "Poppins-Medium"
    case regular = "Poppins-Regular"
    case semibold = "Poppins-Semibold"
    case bold = "Poppins-Bold"
}

extension UILabel {
    func setTitle(text: String, size: CGFloat, weight: labelWeight) {
        guard let customFont = UIFont(name: weight.rawValue, size: size) else { return }
        let attributedText = NSMutableAttributedString(
            string: text, attributes: [.font: customFont]
        )
        self.attributedText = attributedText
    }
    
    func setTitle(text: String, size: CGFloat, weight: labelWeight, color: UIColor) {
        guard let customFont = UIFont(name: weight.rawValue, size: size) else { return }
        let attributedText = NSMutableAttributedString(
            string: text, attributes: [
                .font: customFont,
                .foregroundColor : color
            ]
        )
        self.attributedText = attributedText
    }
}
