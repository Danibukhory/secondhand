//
//  SHPopupView.swift
//  SecondHand
//
//  Created by Bagas Ilham on 21/06/22.
//

import UIKit

final class SHPopupView: UIView {
    
    var popupTextLabel = UILabel()
    var dismissButton = UIButton()
    
    typealias OnDismissButtonTap = () -> Void
    var onDismissButtonTap: OnDismissButtonTap?
    
    var topAnchorConstraint: NSLayoutYAxisAnchor?
    var isPresenting: Bool = false {
        didSet {
            if isPresenting {
                self.fadeIn()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.isPresenting = false
                }
            } else {
                fadeOut()
            }
        }
    }
    
    enum PopupType {
        case success
        case failed
    }
    
    init(frame: CGRect, popupType: PopupType, text: String) {
        super.init(frame: frame)
        self.alpha = 0
        self.popupTextLabel.setTitle(text: text, size: 14, weight: .medium, color: .white)
        switch popupType {
        case .success:
            self.backgroundColor = UIColor(rgb: 0x73CA5C)
        case .failed:
            self.backgroundColor = UIColor.systemRed
        }
        self.defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        addSubviews(popupTextLabel, dismissButton)
        setTranslatesAutoresizingMaskIntoConstraintsToFalse(self, popupTextLabel, dismissButton)
        layer.cornerRadius = 12
        clipsToBounds = true
        
        popupTextLabel.numberOfLines = 0
        popupTextLabel.textAlignment = .left
        
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        dismissButton.tintColor = .white
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 52),
            
            popupTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            popupTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            popupTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            popupTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            dismissButton.heightAnchor.constraint(equalToConstant: 24),
            dismissButton.widthAnchor.constraint(equalTo: dismissButton.heightAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: popupTextLabel.trailingAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            dismissButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    @objc private func dismissTapped() {
        onDismissButtonTap?()
        self.isPresenting = false
    }
    
}
