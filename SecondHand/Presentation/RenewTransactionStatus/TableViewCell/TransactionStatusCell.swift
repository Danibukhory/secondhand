//
//  TransactionStatusCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 23/06/22.
//

import UIKit

final class TransactionStatusCell: UITableViewCell {
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var statusDetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var radioButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xD0D0D0)
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    var radioButtonSelected: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x7126B5)
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.alpha = 0
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.backgroundColor = .white
        let view = contentView
        let margin = view.layoutMarginsGuide
        view.addSubviews(radioButton, radioButtonSelected, statusLabel, statusDetailLabel)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            
            radioButton.topAnchor.constraint(equalTo: margin.topAnchor),
            radioButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            radioButtonSelected.centerXAnchor.constraint(equalTo: radioButton.centerXAnchor),
            radioButtonSelected.centerYAnchor.constraint(equalTo: radioButton.centerYAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: radioButton.topAnchor, constant: -2),
            statusLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            statusDetailLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            statusDetailLabel.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            statusDetailLabel.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            statusDetailLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
        ])
    }
    
    func selected() {
        radioButtonSelected.alpha = 1
    }
    
    func deselected() {
        radioButtonSelected.alpha = 0
    }
    
}
