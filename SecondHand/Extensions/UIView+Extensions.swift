//
//  UIView+Extensions.swift
//  SecondHand
//
//  Created by Raden Dimas on 14/06/22.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach{
            addSubview($0)
        }
    }
}
