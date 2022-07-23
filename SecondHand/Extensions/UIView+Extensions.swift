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
    
    func fadeIn(
        _ duration: TimeInterval = 0.15,
        delay: TimeInterval = 0.0,
        completion: @escaping ((Bool) -> Void) = { (finished: Bool) -> Void in }
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { self.alpha = 1.0 },
            completion: completion
        )
    }
    
    func fadeInWithScale(
        _ duration: TimeInterval = 0.15,
        delay: TimeInterval = 0.0,
        completion: @escaping ((Bool) -> Void) = { (finished: Bool) -> Void in }
    ) {
        self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
            completion: completion
        )
    }
    
    func fadeOut(
        _ duration: TimeInterval = 0.15,
        delay: TimeInterval = 0.0,
        completion: @escaping (Bool) -> Void = { (finished: Bool) -> Void in}
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { self.alpha = 0.0 },
            completion: completion
        )
    }
    
    func fadeOutWithScale(
        _ duration: TimeInterval = 0.15,
        delay: TimeInterval = 0.0,
        completion: @escaping (Bool) -> Void = { (finished: Bool) -> Void in}
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                self.alpha = 0.0
                self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            },
            completion: completion
        )
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


  

