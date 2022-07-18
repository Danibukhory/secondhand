//
//  NotificationDetailSellerCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 18/07/22.
//

import UIKit
import Kingfisher

final class NotificationDetailCell: UITableViewCell {
    
    var sellerImageView = UIImageView()
    var sellerNameLabel = UILabel()
    var sellerCityLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sellerImageView.image = nil
        sellerNameLabel.attributedText = nil
        sellerCityLabel.attributedText = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubviews(sellerImageView, sellerNameLabel, sellerCityLabel)
        contentView.setTranslatesAutoresizingMaskIntoConstraintsToFalse(sellerImageView, sellerNameLabel, sellerCityLabel)
        contentView.backgroundColor = .white
        
        sellerImageView.clipsToBounds = true
        sellerImageView.contentMode = .scaleAspectFill
        sellerImageView.layer.cornerRadius = 12
        sellerImageView.clipsToBounds = true
        
        sellerNameLabel.numberOfLines = 1
        
        sellerCityLabel.numberOfLines = 1
        
        let margin = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            sellerImageView.centerYAnchor.constraint(equalTo: margin.centerYAnchor),
            sellerImageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            sellerImageView.heightAnchor.constraint(equalToConstant: 48),
            sellerImageView.widthAnchor.constraint(equalTo: sellerImageView.heightAnchor),
            
            sellerNameLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor, constant: -5),
            sellerNameLabel.leadingAnchor.constraint(equalTo: sellerImageView.trailingAnchor, constant: 16),
            sellerNameLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            sellerCityLabel.topAnchor.constraint(equalTo: sellerNameLabel.bottomAnchor),
            sellerCityLabel.leadingAnchor.constraint(equalTo: sellerNameLabel.leadingAnchor),
            sellerCityLabel.trailingAnchor.constraint(equalTo: sellerNameLabel.trailingAnchor)
        ])
    }
    
    func fill(with data: SHUserResponse) {
        if let imageUrl = URL(string: data.imageURL ?? "") {
            sellerImageView.kf.setImage(
                with: imageUrl,
                options: [.transition(.fade(0.2))]
            )
        }
        sellerNameLabel.setTitle(
            text: data.fullName ?? "Name not available",
            size: 14,
            weight: .medium,
            color: .black
        )
        sellerCityLabel.setTitle(
            text: data.city ?? "Domicile not available",
            size: 10,
            weight: .regular,
            color: UIColor(rgb: 0x8A8A8A)
        )
    }
    
    func fill(with data: SHNotificationResponse) {
        if let imageUrl = URL(string: data.product?.imageURL ?? "") {
            sellerImageView.kf.setImage(
                with: imageUrl,
                options: [.transition(.fade(0.2))]
            )
        }
        sellerNameLabel.setTitle(
            text: data.productName ?? "Name not available",
            size: 14,
            weight: .medium,
            color: .black
        )
        sellerCityLabel.setTitle(
            text: data.bidPrice?.convertToCurrency() ?? "Bid price not available",
            size: 10,
            weight: .regular,
            color: UIColor(rgb: 0x8A8A8A)
        )
    }
    
}

