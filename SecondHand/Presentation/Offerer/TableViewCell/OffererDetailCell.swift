//
//  OffererDetailCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 20/06/22.
//

import UIKit
import Kingfisher

final class OffererDetailCell: UITableViewCell {
    
    var borderView = UIView()
    var offererImageView = UIImageView()
    var offererNameLabel = UILabel()
    var offererCityLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        offererImageView.image = nil
        offererNameLabel.attributedText = nil
        offererCityLabel.attributedText = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.addSubview(borderView)
        borderView.addSubviews(offererImageView, offererNameLabel, offererCityLabel)
        contentView.setTranslatesAutoresizingMaskIntoConstraintsToFalse(borderView, offererImageView, offererNameLabel, offererCityLabel)
        contentView.backgroundColor = .white
        
        borderView.backgroundColor = .white
        borderView.layer.cornerRadius = 16
        borderView.clipsToBounds = true
        borderView.layer.masksToBounds = false
        borderView.layer.shadowRadius = 2
        borderView.layer.shadowColor = UIColor.black.cgColor
        borderView.layer.shadowOpacity = 0.2
        borderView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        offererImageView.clipsToBounds = true
        offererImageView.contentMode = .scaleAspectFill
        offererImageView.layer.cornerRadius = 12
        offererImageView.clipsToBounds = true
        
        offererNameLabel.numberOfLines = 1
        
        offererCityLabel.numberOfLines = 1
        
        let margin = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            
            borderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            borderView.topAnchor.constraint(equalTo: margin.topAnchor),
            borderView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 80),
            borderView.widthAnchor.constraint(equalTo: margin.widthAnchor),
            
            offererImageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            offererImageView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 16),
            offererImageView.heightAnchor.constraint(equalToConstant: 48),
            offererImageView.widthAnchor.constraint(equalTo: offererImageView.heightAnchor),
            
            offererNameLabel.centerYAnchor.constraint(equalTo: borderView.centerYAnchor, constant: -5),
            offererNameLabel.leadingAnchor.constraint(equalTo: offererImageView.trailingAnchor, constant: 16),
            offererNameLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16),
            
            offererCityLabel.topAnchor.constraint(equalTo: offererNameLabel.bottomAnchor),
            offererCityLabel.leadingAnchor.constraint(equalTo: offererNameLabel.leadingAnchor),
            offererCityLabel.trailingAnchor.constraint(equalTo: offererNameLabel.trailingAnchor)
        ])
    }
    
    func fill(with data: SHOrderBuyer) {
        offererImageView.image = UIImage(systemName: "person.crop.square.fill")?.withTintColor(UIColor(rgb: 0x7126B5), renderingMode: .alwaysOriginal)
        offererImageView.contentMode = .scaleAspectFit
        
        offererNameLabel.setTitle(
            text: data.fullName,
            size: 14,
            weight: .medium, color: .black
        )
        
        offererCityLabel.setTitle(
            text: data.city,
            size: 10,
            weight: .regular,
            color: UIColor(rgb: 0x8A8A8A)
        )
    }
    
}
