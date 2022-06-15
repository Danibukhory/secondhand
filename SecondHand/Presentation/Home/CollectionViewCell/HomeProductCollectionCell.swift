//
//  HomeProductCollectionCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

final class HomeProductCollectionCell: UICollectionViewCell {
    
    var productImageView = UIImageView()
    var productNameLabel = UILabel()
    var productCategoryLabel = UILabel()
    var productPriceLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productNameLabel.attributedText = nil
        productCategoryLabel.attributedText = nil
        productPriceLabel.attributedText = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubviews(productImageView, productNameLabel, productCategoryLabel, productPriceLabel)
        contentView.setTranslatesAutoresizingMaskIntoConstraintsToFalse(productImageView, productNameLabel, productCategoryLabel, productPriceLabel)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowPath = UIBezierPath(roundedRect: bounds,cornerRadius: 8).cgPath
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 4
        
        productNameLabel.setTitle(text: "Name Placeholder", size: 14, weight: .regular)
        
        productCategoryLabel.setTitle(text: "Category Placeholder", size: 10, weight: .regular, color: .secondaryLabel)
        
        productPriceLabel.setTitle(text: "Rp 199.000", size: 14, weight: .regular)
        
        NSLayoutConstraint.activate([
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.heightAnchor.constraint(equalToConstant: 100),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),
            
            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            productCategoryLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 4),
            productCategoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productCategoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productCategoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            productPriceLabel.topAnchor.constraint(equalTo: productCategoryLabel.bottomAnchor, constant: 6),
            productPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            productPriceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 206),
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 156)
        ])
    }
}

