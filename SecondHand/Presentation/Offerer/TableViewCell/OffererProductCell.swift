//
//  OffererProductCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 20/06/22.
//

import UIKit

final class OffererProductCell: UITableViewCell {
    
    var productImageView = UIImageView()
    var offerTypeLabel = UILabel()
    var productNameLabel = UILabel()
    var offerValueLabel = UILabel()
    var offerTimeLabel = UILabel()
    var rejectButton = SHBorderedButton()
    var acceptButton = SHDefaultButton()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func defineLayout() {
        contentView.addSubviews(productImageView, offerTypeLabel, productNameLabel, offerValueLabel, offerTimeLabel, rejectButton, acceptButton)
        contentView.setTranslatesAutoresizingMaskIntoConstraintsToFalse(productImageView, offerTypeLabel, productNameLabel, offerValueLabel, offerTimeLabel, rejectButton, acceptButton)
        
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        productImageView.image = UIImage(named: "img-home-product-placeholder-1")
        
        offerTypeLabel.numberOfLines = 1
        offerTypeLabel.setTitle(text: "Penawaran produk", size: 10, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        
        productNameLabel.numberOfLines = 1
        productNameLabel.setTitle(text: "Apple Watch Series 6", size: 14, weight: .regular, color: .black)
        
        offerValueLabel.numberOfLines = 0
        offerValueLabel.setTitle(text: "Rp 5.999.999\nDitawar Rp 10.000", size: 14, weight: .regular, color: .black)
        
        offerTimeLabel.numberOfLines = 1
        offerTimeLabel.textAlignment = .right
        offerTimeLabel.setTitle(text: "20 Jun, 22.22", size: 10, weight: .regular, color: UIColor(rgb: 0x8A8A8A))
        
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
            
            offerValueLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            offerValueLabel.leadingAnchor.constraint(equalTo: offerTypeLabel.leadingAnchor),
            offerValueLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor),
            
            offerTimeLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            offerTimeLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            rejectButton.topAnchor.constraint(equalTo: offerValueLabel.bottomAnchor, constant: 16),
            rejectButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            rejectButton.heightAnchor.constraint(equalToConstant: 36),
            rejectButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 16 * 2),
            
            acceptButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            acceptButton.topAnchor.constraint(equalTo: rejectButton.topAnchor),
            acceptButton.heightAnchor.constraint(equalTo: rejectButton.heightAnchor),
            acceptButton.widthAnchor.constraint(equalTo: rejectButton.widthAnchor),
            acceptButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
    @objc private func rejectTapped() {
        onRejectButtonTap?()
    }
    
    @objc private func acceptTapped() {
        onAcceptButtonTap?()
    }
    
}
