//
//  HomeNewProductCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 24/07/22.
//

import UIKit
import Kingfisher

final class HomeNewProductCell: UITableViewCell {
    var leftProductView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.isUserInteractionEnabled = true
        return view
    }()
    var leftProductImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    var leftProductNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    var leftProductCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var leftProductPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var rightProductView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.isUserInteractionEnabled = true
        return view
    }()
    var rightProductImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    var rightProductNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    var rightProductCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var rightProductPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var onLeftProductTap: (() -> Void)?
    var onRightProductTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubviews(leftProductView, rightProductView)
        leftProductView.addSubviews(leftProductImageView, leftProductNameLabel, leftProductPriceLabel, leftProductCategoryLabel)
        rightProductView.addSubviews(rightProductImageView, rightProductNameLabel, rightProductPriceLabel, rightProductCategoryLabel)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 222),
            
            leftProductView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftProductView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            leftProductView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            leftProductView.heightAnchor.constraint(equalToConstant: 206),
            leftProductView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 48) / 2),
            
            leftProductImageView.centerXAnchor.constraint(equalTo: leftProductView.centerXAnchor),
            leftProductImageView.topAnchor.constraint(equalTo: leftProductView.topAnchor, constant: 8),
            leftProductImageView.widthAnchor.constraint(equalTo: leftProductView.widthAnchor, constant: -16),
            leftProductImageView.heightAnchor.constraint(equalToConstant: 100),
            
            leftProductNameLabel.topAnchor.constraint(equalTo: leftProductImageView.bottomAnchor, constant: 8),
            leftProductNameLabel.leadingAnchor.constraint(equalTo: leftProductView.leadingAnchor, constant: 8),
            leftProductNameLabel.trailingAnchor.constraint(equalTo: leftProductView.trailingAnchor, constant: -8),
            
            leftProductCategoryLabel.topAnchor.constraint(equalTo: leftProductNameLabel.bottomAnchor, constant: 4),
            leftProductCategoryLabel.leadingAnchor.constraint(equalTo: leftProductNameLabel.leadingAnchor),
            leftProductCategoryLabel.trailingAnchor.constraint(equalTo: leftProductNameLabel.trailingAnchor),
            
            leftProductPriceLabel.topAnchor.constraint(equalTo: leftProductCategoryLabel.bottomAnchor, constant: 6),
            leftProductPriceLabel.leadingAnchor.constraint(equalTo: leftProductNameLabel.leadingAnchor),
            leftProductPriceLabel.trailingAnchor.constraint(equalTo: leftProductNameLabel.trailingAnchor),
            leftProductPriceLabel.bottomAnchor.constraint(equalTo: leftProductView.bottomAnchor, constant: -24),
            
            rightProductView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightProductView.topAnchor.constraint(equalTo: leftProductView.topAnchor),
            rightProductView.bottomAnchor.constraint(equalTo: leftProductView.bottomAnchor),
            rightProductView.heightAnchor.constraint(equalTo: leftProductView.heightAnchor),
            rightProductView.widthAnchor.constraint(equalTo: leftProductView.widthAnchor),
            
            rightProductImageView.centerXAnchor.constraint(equalTo: rightProductView.centerXAnchor),
            rightProductImageView.topAnchor.constraint(equalTo: rightProductView.topAnchor, constant: 8),
            rightProductImageView.widthAnchor.constraint(equalTo: rightProductView.widthAnchor, constant: -16),
            rightProductImageView.heightAnchor.constraint(equalTo: leftProductImageView.heightAnchor),
            
            rightProductNameLabel.topAnchor.constraint(equalTo: rightProductImageView.bottomAnchor, constant: 8),
            rightProductNameLabel.leadingAnchor.constraint(equalTo: rightProductView.leadingAnchor, constant: 8),
            rightProductNameLabel.trailingAnchor.constraint(equalTo: rightProductView.trailingAnchor, constant: -8),
            
            rightProductCategoryLabel.topAnchor.constraint(equalTo: rightProductNameLabel.bottomAnchor, constant: 4),
            rightProductCategoryLabel.leadingAnchor.constraint(equalTo: rightProductNameLabel.leadingAnchor),
            rightProductCategoryLabel.trailingAnchor.constraint(equalTo: rightProductNameLabel.trailingAnchor),
            
            rightProductPriceLabel.topAnchor.constraint(equalTo: rightProductCategoryLabel.bottomAnchor, constant: 6),
            rightProductPriceLabel.leadingAnchor.constraint(equalTo: rightProductNameLabel.leadingAnchor),
            rightProductPriceLabel.trailingAnchor.constraint(equalTo: rightProductNameLabel.trailingAnchor),
            rightProductPriceLabel.bottomAnchor.constraint(equalTo: rightProductView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupGestureRecognizers() {
        let leftTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(leftProductTapped))
        leftProductView.addGestureRecognizer(leftTapRecognizer)
        let rightTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightProductTapped))
        rightProductView.addGestureRecognizer(rightTapRecognizer)
    }
    
    func fill(with leftProduct: SHBuyerProductResponse, and rightProduct: SHBuyerProductResponse?) {
        contentView.fadeOut()
        if let leftUrl = URL(string: leftProduct.imageURL) {
            leftProductImageView.kf.indicatorType = .activity
            leftProductImageView.kf.setImage(with: leftUrl, options: [.transition(.fade(0.25)), .cacheOriginalImage])
        }
        leftProductNameLabel.setTitle(
            text: leftProduct.name,
            size: 14,
            weight: .regular,
            color: .black
        )
        if !leftProduct.categories.isEmpty {
            leftProductCategoryLabel.setTitle(
                text: leftProduct.categories[0].name ?? "",
                size: 10,
                weight: .regular,
                color: .secondaryLabel
            )
        }
        leftProductPriceLabel.setTitle(
            text: "\(leftProduct.basePrice)".convertToCurrency(),
            size: 14,
            weight: .regular,
            color: .black
        )
        
        if let _rightProduct = rightProduct {
            rightProductView.alpha = 1
            rightProductView.isUserInteractionEnabled = true
            if let rightUrl = URL(string: _rightProduct.imageURL) {
                rightProductImageView.kf.indicatorType = .activity
                rightProductImageView.kf.setImage(with: rightUrl, options: [.transition(.fade(0.25)), .cacheOriginalImage])
            }
            rightProductNameLabel.setTitle(
                text: _rightProduct.name,
                size: 14,
                weight: .regular,
                color: .black
            )
            if !_rightProduct.categories.isEmpty {
                rightProductCategoryLabel.setTitle(
                    text: _rightProduct.categories[0].name ?? "",
                    size: 10,
                    weight: .regular,
                    color: .secondaryLabel
                )
            }
            rightProductPriceLabel.setTitle(
                text: "\(_rightProduct.basePrice)".convertToCurrency(),
                size: 14,
                weight: .regular,
                color: .black
            )
        } else {
            rightProductView.alpha = 0
            rightProductView.isUserInteractionEnabled = false
            rightProductImageView.image = nil
            rightProductNameLabel.setTitle(text: "", size: 14, weight: .regular)
            rightProductPriceLabel.setTitle(text: "", size: 14, weight: .regular)
            rightProductCategoryLabel.setTitle(text: "", size: 14, weight: .regular)
        }
        contentView.fadeIn()
    }
    
    @objc private func leftProductTapped() {
        onLeftProductTap?()
    }
    
    @objc private func rightProductTapped() {
        onRightProductTap?()
    }
}
