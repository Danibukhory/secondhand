//
//  TopSellingListTableViewCell.swift
//  SecondHand
//
//  Created by Raden Dimas on 19/06/22.
//

import UIKit

final class TopSellingListTableViewCell: UITableViewCell {
    
    let identifier: String = "tp-sllist-cell"
    
    private lazy var topContainerView: UIView = {
        let topContainer = UIView()
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.backgroundColor = UIColor.systemBackground
        topContainer.layer.cornerRadius = 16
        topContainer.layer.borderColor = UIColor.lightGray.cgColor
        topContainer.layer.borderWidth = 1
        topContainer.layer.shadowColor = UIColor.black.cgColor
        topContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        topContainer.layer.shadowOpacity = 0.7
        topContainer.layer.shadowRadius = 1.8
        return topContainer
    }()
    
    private lazy var imageTopView: UIImageView = {
        let imageTop = UIImageView()
        return imageTop
    }()
    
    
    private lazy var sellerNameLabel: UILabel = {
       let sellerName = UILabel()
        return sellerName
    }()
    
    private lazy var sellerCityLabel: UILabel = {
        let sellerCity = UILabel()
        return sellerCity
    }()
    
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        return editButton
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
        
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: topAnchor),
            topContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            topContainerView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
        ])
        
    }

}
