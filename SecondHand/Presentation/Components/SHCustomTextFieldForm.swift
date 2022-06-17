//
//  SHCustomTextFieldForm.swift
//  SecondHand
//
//  Created by Daffashiddiq on 16/06/22.
//

import Foundation
import UIKit

class SHCustomTextFieldForm: UITableViewCell {
    lazy var namaCustom: String = ""
    lazy var placeHolderCustom: String = ""
    
    public func setTextFieldName (nama name: String, placeHolderLabel placeHolder: String) {
        self.namaCustom = name
        self.placeHolderCustom = placeHolder
    }
    
    lazy var customLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.text = namaCustom
         return label
    }()
    
    lazy var customTextField: SHRoundedTextfield = {
        let textField = SHRoundedTextfield()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setPlaceholder(placeholder: placeHolderCustom)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addConfiguration() {
        addConstraintForTextField()
    }
    
    public func addConstraintForTextField() {
        let margin = contentView.layoutMarginsGuide
        contentView.addSubviews(
            customLabel,
            customTextField
        )
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            
            customTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customTextField.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 4),
            customTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            customTextField.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
        ])
    }
    
}
