//
//  UIView+Extensions.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach{
            addSubview($0)
        }
    }
}
