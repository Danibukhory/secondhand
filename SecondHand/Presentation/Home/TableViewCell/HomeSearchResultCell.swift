//
//  HomeSearchResultCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 10/07/22.
//

import UIKit
import Kingfisher

final class HomeSearchResultCell: UITableViewCell {
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubviews(productImageView, productNameLabel, productPriceLabel, productCategoryLabel)
        
        let margin = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: margin.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 72),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            productNameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            productPriceLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            productPriceLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor),
            
            productCategoryLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor),
            productCategoryLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            productCategoryLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
    
    func fill(with data: SHBuyerProductResponse) {
//        if let imageUrlString = data.imageURL {
//            let url = URL(string: imageUrlString)
//            productImageView.kf.indicatorType = .activity
//            productImageView.kf.setImage(with: url, options: [.cacheOriginalImage, .transition(.fade(0.2))])
//        }
        let url = URL(string: data.imageURL)
        productImageView.kf.indicatorType = .activity
        productImageView.kf.setImage(with: url, options: [.cacheOriginalImage, .transition(.fade(0.2))])
        productNameLabel.setTitle(text: data.name, size: 14, weight: .medium, color: .black)
//        if let price = data.basePrice {
//            productPriceLabel.setTitle(text: price.convertToCurrency(), size: 14, weight: .regular, color: .black)
//        }
        productPriceLabel.setTitle(text: data.basePrice.convertToCurrency(), size: 14, weight: .regular, color: .black)
        if !data.categories.isEmpty {
            let category = data.categories[0]
            productCategoryLabel.setTitle(text: category.name ?? "Recommended for you", size: 10, weight: .regular, color: .secondaryLabel)
        }
    }
}
