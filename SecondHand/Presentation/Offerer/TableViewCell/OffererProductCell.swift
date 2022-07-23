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
    var declineButton = SHButton(frame: CGRect(), title: "Tolak", type: .bordered, size: .small)
    var acceptButton = SHButton(frame: CGRect(), title: "Terima", type: .filled, size: .small)
    var productSoldButton = SHButton(frame: CGRect(), title: "Produk sudah terjual ke pembeli lain", type: .ghost, size: .regular)
    var offerRejectedButton = SHButton(frame: CGRect(), title: "Penawaran ini sudah anda tolak", type: .ghost, size: .regular)
    var declineButtonLoadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(rgb: 0x7126B5)
        return indicator
    }()
    var acceptButtonLoadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    var outerLoadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(rgb: 0x7126B5)
        return indicator
    }()
    
    typealias OnRejectButtonTap = () -> Void
    var onDeclineButtonTap: OnRejectButtonTap?
    
    typealias OnAcceptButtonTap = () -> Void
    var onAcceptButtonTap: OnAcceptButtonTap?
    
    typealias OnSoldButtonTap = () -> Void
    var onSoldButtonTap: OnSoldButtonTap?
    
    typealias OnOfferRejectedButtonTap = () -> Void
    var onOfferRejectedButtonTap: OnOfferRejectedButtonTap?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubviews(productImageView, offerTypeLabel, productNameLabel, bidValueLabel, offerTimeLabel, declineButton, acceptButton, productSoldButton, offerRejectedButton, outerLoadingView)
        contentView.setTranslatesAutoresizingMaskIntoConstraintsToFalse(productImageView, offerTypeLabel, productNameLabel, bidValueLabel, offerTimeLabel, declineButton, acceptButton, productSoldButton, offerRejectedButton)
        contentView.backgroundColor = .white
        declineButton.addSubview(declineButtonLoadingView)
        acceptButton.addSubview(acceptButtonLoadingView)
        
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
        
        declineButton.setActiveButtonTitle(string: "Tolak")
        declineButton.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)
        
        productSoldButton.alpha = 0
        productSoldButton.addTarget(self, action: #selector(soldTapped), for: .touchUpInside)
        
        offerRejectedButton.alpha = 0
        offerRejectedButton.addTarget(self, action: #selector(offerRejectedTapped), for: .touchUpInside)
        
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
            
            declineButton.topAnchor.constraint(equalTo: bidValueLabel.bottomAnchor, constant: 16),
            declineButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            declineButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 16 * 2),
            
            declineButtonLoadingView.centerXAnchor.constraint(equalTo: declineButton.centerXAnchor),
            declineButtonLoadingView.centerYAnchor.constraint(equalTo: declineButton.centerYAnchor),
            
            acceptButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            acceptButton.topAnchor.constraint(equalTo: declineButton.topAnchor),
            acceptButton.widthAnchor.constraint(equalTo: declineButton.widthAnchor),
            acceptButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
            acceptButtonLoadingView.centerXAnchor.constraint(equalTo: acceptButton.centerXAnchor),
            acceptButtonLoadingView.centerYAnchor.constraint(equalTo: acceptButton.centerYAnchor),
            
            productSoldButton.widthAnchor.constraint(equalTo: margin.widthAnchor),
            productSoldButton.topAnchor.constraint(equalTo: declineButton.topAnchor),
            productSoldButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            offerRejectedButton.widthAnchor.constraint(equalTo: margin.widthAnchor),
            offerRejectedButton.topAnchor.constraint(equalTo: declineButton.topAnchor),
            offerRejectedButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            outerLoadingView.centerYAnchor.constraint(equalTo: offerRejectedButton.centerYAnchor),
            outerLoadingView.centerXAnchor.constraint(equalTo: margin.centerXAnchor)
        ])
    }
    
    func fill(with data: SHNotificationResponse) {
        if let urlString = URL(string: data.imageURL) {
            productImageView.kf.setImage(with: urlString, options: [.transition(.fade(0.2))])
        }
        offerTypeLabel.setTitle(
            text: "Penawaran produk",
            size: 10,
            weight: .regular,
            color: UIColor(rgb: 0x8A8A8A)
        )
        productNameLabel.setTitle(
            text: data.productName,
            size: 14,
            weight: .regular,
            color: .black
        )
//        let basePriceInt = Int(data.basePrice ?? "")
        let basePriceInt = data.basePrice
        if data.bidPrice != nil {
            bidValueLabel.setTitle(
                text: "\(basePriceInt.convertToCurrency() )\nDitawar \(data.bidPrice?.convertToCurrency() ?? "bid price not available")",
                size: 14,
                weight: .regular,
                color: .black
            )
        } else {
            bidValueLabel.setTitle(
                text: "\(basePriceInt.convertToCurrency())",
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
        onDeclineButtonTap?()
    }
    
    @objc private func acceptTapped() {
        onAcceptButtonTap?()
    }
    
    @objc private func soldTapped() {
        onSoldButtonTap?()
    }
    
    @objc private func offerRejectedTapped() {
        onOfferRejectedButtonTap?()
    }
    
}
