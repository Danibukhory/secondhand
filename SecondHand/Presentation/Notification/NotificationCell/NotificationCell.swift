//
//  NotificationCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 16/06/22.
//

import UIKit

final class NotificationCell: UITableViewCell {
    
    var notificationImageView = UIImageView()
    var notificationCategoryLabel = UILabel()
    var notificationContentLabel = UILabel()
    var notificationTimeLabel = UILabel()
    var notificationBadge = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        notificationImageView.image = nil
        notificationCategoryLabel.attributedText = nil
        notificationContentLabel.attributedText = nil
        notificationTimeLabel.attributedText = nil
    }
    
    private func defineLayout() {
        contentView.addSubviews(
            notificationImageView,
            notificationCategoryLabel,
            notificationContentLabel,
            notificationTimeLabel,
            notificationBadge
        )
        contentView.setTranslatesAutoresizingMaskIntoConstraintsToFalse(
            notificationImageView,
            notificationCategoryLabel,
            notificationContentLabel,
            notificationTimeLabel,
            notificationBadge
        )
        backgroundColor = .white
        
        notificationImageView.clipsToBounds = true
        notificationImageView.contentMode = .scaleAspectFill
        notificationImageView.layer.cornerRadius = 12
        notificationImageView.image = UIImage(named: "img-home-product-placeholder-1")
        
        notificationCategoryLabel.setTitle(text: "Penawaran produk", size: 10, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        notificationCategoryLabel.numberOfLines = 1
        
        notificationContentLabel.setTitle(text: "Apple Watch Series 6\nRp 5.999.999\nDitawar Rp 10.000", size: 14, weight: .regular, color: UIColor.black)
        notificationContentLabel.numberOfLines = 0
        
        notificationTimeLabel.setTitle(text: "16 Jun, 09:41", size: 10, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        notificationTimeLabel.numberOfLines = 1
        
        notificationBadge.layer.cornerRadius = 4
        notificationBadge.clipsToBounds = true
        notificationBadge.backgroundColor = UIColor(rgb: 0xFA2C5A)
        
        let margin = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            notificationImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            notificationImageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            notificationImageView.heightAnchor.constraint(equalToConstant: 48),
            notificationImageView.widthAnchor.constraint(equalTo: notificationImageView.heightAnchor),
            
            notificationCategoryLabel.leadingAnchor.constraint(equalTo: notificationImageView.trailingAnchor, constant: 16),
            notificationCategoryLabel.topAnchor.constraint(equalTo: notificationImageView.topAnchor),
            
            notificationContentLabel.topAnchor.constraint(equalTo: notificationCategoryLabel.bottomAnchor),
            notificationContentLabel.leadingAnchor.constraint(equalTo: notificationCategoryLabel.leadingAnchor),
            notificationContentLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
            notificationBadge.topAnchor.constraint(equalTo: notificationImageView.topAnchor, constant: 2),
            notificationBadge.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            notificationBadge.heightAnchor.constraint(equalToConstant: 8),
            notificationBadge.widthAnchor.constraint(equalTo: notificationBadge.heightAnchor),
            
            notificationTimeLabel.topAnchor.constraint(equalTo: notificationImageView.topAnchor),
            notificationTimeLabel.trailingAnchor.constraint(equalTo: notificationBadge.leadingAnchor, constant: -8)
        ])
    }
}

