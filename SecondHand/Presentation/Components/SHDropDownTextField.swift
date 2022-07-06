//
//  SHDropDownTextField.swift
//  SecondHand
//
//  Created by Daffashiddiq on 20/06/22.
//

import UIKit
import iOSDropDown

final class SHDropDownTextField: DropDown {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.offsetBy(dx: -24, dy: 0)
    }

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        return rect.offsetBy(dx: -24, dy: 0)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont(name: "Poppins-Regular", size: 14)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = .systemBackground
        clearButtonMode = .whileEditing
        rowHeight = 48
        checkMarkEnabled = false
        selectedRowColor = UIColor.systemGray
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    public func setPlaceholder(placeholder: String) {
        self.placeholder = placeholder
    }
    
}
