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
    
    func setTranslatesAutoresizingMaskIntoConstraintsToFalse(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func constraintsPinTo(leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor, top: NSLayoutYAxisAnchor, bottom: NSLayoutYAxisAnchor) {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: leading),
                self.trailingAnchor.constraint(equalTo: trailing),
                self.topAnchor.constraint(equalTo: top),
                self.bottomAnchor.constraint(equalTo: bottom)
                ])
    }
}
