//
//  TopSellingListTableViewCell.swift
//  SecondHand
//
//  Created by Raden Dimas on 19/06/22.
//

import UIKit

final class TopSellingListTableViewCell: UITableViewCell {
    
    static let identifier: String = "tp-sllist-cell"
    
    private lazy var topContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 1.8
        return containerView
    }()
    
    private lazy var imageTopView: UIImageView = {
        let imageTop = UIImageView()
        imageTop.translatesAutoresizingMaskIntoConstraints = false
        imageTop.backgroundColor = .blue
        imageTop.layer.cornerRadius = 12
        return imageTop
    }()
    
    private lazy var sellerNameLabel: UILabel = {
       let sellerName = UILabel()
        sellerName.translatesAutoresizingMaskIntoConstraints = false
        sellerName.text = "Nama Penjual"
        sellerName.font = UIFont(name: "Poppins-SemiBold", size: 14)
        return sellerName
    }()
    
    private lazy var sellerCityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.text = "Kota"
        cityLabel.font = UIFont(name: "Poppins-Light", size: 10)
        return cityLabel
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(rgb: 0x7126B5).cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        let attributedTitle = NSAttributedString(
            string: "Edit",
            attributes: [.font : UIFont(name: "Poppins-Regular", size: 12)!]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellView() {
        contentView.addSubview(topContainerView)
        topContainerView.addSubviews(
            imageTopView,
            sellerNameLabel,
            sellerCityLabel,
            editButton
        )
        
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: topAnchor),
            topContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            topContainerView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            
            imageTopView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor,constant: 16),
            imageTopView.topAnchor.constraint(equalTo: topContainerView.topAnchor,constant:16),
            imageTopView.heightAnchor.constraint(equalToConstant: 48),
            imageTopView.widthAnchor.constraint(equalToConstant: 48),
            
            sellerNameLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 16),
            sellerNameLabel.leadingAnchor.constraint(equalTo: imageTopView.trailingAnchor, constant: 16),

            sellerCityLabel.topAnchor.constraint(equalTo: sellerNameLabel.bottomAnchor, constant: 10),
            sellerCityLabel.leadingAnchor.constraint(equalTo: imageTopView.trailingAnchor, constant: 16),
            
            editButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -16),
            editButton.widthAnchor.constraint(equalToConstant: 60),
            editButton.heightAnchor.constraint(equalToConstant: 26),
            
        ])
        
    }

}
