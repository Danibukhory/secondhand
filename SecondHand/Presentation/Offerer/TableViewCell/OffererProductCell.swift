//
//  OffererProductCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 20/06/22.
//

import UIKit
import Kingfisher

final class OffererProductCell: UITableViewCell {
    
    var productImageView = UIImageView()
    var offerTypeLabel = UILabel()
    var productNameLabel = UILabel()
    var bidValueLabel = UILabel()
    var offerTimeLabel = UILabel()
    var rejectButton = SHButton(frame: CGRect(), title: "Tolak", type: .bordered, size: .small)
    var acceptButton = SHButton(frame: CGRect(), title: "Terima", type: .filled, size: .small)
    
    typealias OnRejectButtonTap = () -> Void
    var onRejectButtonTap: OnRejectButtonTap?
    
    typealias OnAcceptButtonTap = () -> Void
    var onAcceptButtonTap: OnAcceptButtonTap?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubviews(productImageView, offerTypeLabel, productNameLabel, bidValueLabel, offerTimeLabel, rejectButton, acceptButton)
        contentView.setTranslatesAutoresizingMaskIntoConstraintsToFalse(productImageView, offerTypeLabel, productNameLabel, bidValueLabel, offerTimeLabel, rejectButton, acceptButton)
        contentView.backgroundColor = .white
        
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        
        offerTypeLabel.numberOfLines = 1
        
        productNameLabel.numberOfLines = 1
        
        bidValueLabel.numberOfLines = 0
        
        offerTimeLabel.numberOfLines = 1
        offerTimeLabel.textAlignment = .right
        
        acceptButton.setActiveButtonTitle(string: "Terima")
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        
        rejectButton.setActiveButtonTitle(string: "Tolak")
        rejectButton.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)
        
        let margin = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
        
            productImageView.topAnchor.constraint(equalTo: margin.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 48),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            
            offerTypeLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            offerTypeLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            offerTypeLabel.trailingAnchor.constraint(equalTo: offerTimeLabel.leadingAnchor, constant: -8),
            
            productNameLabel.topAnchor.constraint(equalTo: offerTypeLabel.bottomAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: offerTypeLabel.leadingAnchor),
            productNameLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            bidValueLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            bidValueLabel.leadingAnchor.constraint(equalTo: offerTypeLabel.leadingAnchor),
            bidValueLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor),
            
            offerTimeLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            offerTimeLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            rejectButton.topAnchor.constraint(equalTo: bidValueLabel.bottomAnchor, constant: 16),
            rejectButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 16 * 2),
            
            acceptButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            acceptButton.topAnchor.constraint(equalTo: rejectButton.topAnchor),
            acceptButton.widthAnchor.constraint(equalTo: rejectButton.widthAnchor),
            acceptButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
    func fill(with data: SHNotificationResponse) {
        if let urlString = URL(string: data.imageURL ?? "") {
            productImageView.kf.setImage(with: urlString, options: [.transition(.fade(0.2))])
        }
        offerTypeLabel.setTitle(
            text: "Penawaran produk",
            size: 10,
            weight: .regular,
            color: UIColor(rgb: 0x8A8A8A)
        )
        productNameLabel.setTitle(
            text: data.productName ?? "Product name not available",
            size: 14,
            weight: .regular,
            color: .black
        )
        let basePriceInt = Int(data.basePrice ?? "")
        if data.bidPrice != nil {
            bidValueLabel.setTitle(
                text: "\(basePriceInt?.convertToCurrency() ?? "")\nDitawar \(data.bidPrice?.convertToCurrency() ?? "bid price not available")",
                size: 14,
                weight: .regular,
                color: .black
            )
        } else {
            bidValueLabel.setTitle(
                text: "\(basePriceInt?.convertToCurrency() ?? "")",
                size: 14,
                weight: .regular,
                color: .black
            )
        }
        offerTimeLabel.setTitle(
            text: data.createdAt?.convertToDateString(dateFormat: "dd MMM, HH:mm") ?? "",
            size: 10,
            weight: .regular,
            color: UIColor(rgb: 0x8A8A8A)
        )
    }
    
    @objc private func rejectTapped() {
        onRejectButtonTap?()
    }
    
    @objc private func acceptTapped() {
        onAcceptButtonTap?()
    }
    
}
