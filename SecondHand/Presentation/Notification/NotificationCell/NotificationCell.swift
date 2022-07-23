//
//  NotificationCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 16/06/22.
//

import UIKit
import Kingfisher

final class NotificationCell: UITableViewCell {
    
    enum notificationProductStatus: String {
        case accepted = "accepted"
        case bid = "bid"
        case declined = "declined"
        case create = "create"
    }
    
    var notificationImageView = UIImageView()
    var notificationCategoryLabel = UILabel()
    var notificationContentLabel = UILabel()
    var notificationTimeLabel = UILabel()
    var notificationBadge = UIView()
    var isRead: Bool = false {
        didSet {
            if isRead {
                widthNotificationBadgeConstraint?.constant = 0
                contentView.layoutIfNeeded()
            } else {
                widthNotificationBadgeConstraint?.constant = 8
                contentView.layoutIfNeeded()
            }
        }
    }
    var loadingBackground = UIView()
    var loadingIndicator = UIActivityIndicatorView()
    var widthNotificationBadgeConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        notificationTimeLabel.attributedText = nil
//        loadingBackground.fadeOut()
//        loadingIndicator.stopAnimating()
//    }
    
    private func defineLayout() {
        contentView.addSubview(notificationBadge)
        contentView.addSubviews(
            notificationImageView,
            notificationCategoryLabel,
            notificationContentLabel,
            notificationTimeLabel,
            loadingBackground
        )
        loadingBackground.addSubview(loadingIndicator)
        contentView.setTranslatesAutoresizingMaskIntoConstraintsToFalse(
            notificationImageView,
            notificationCategoryLabel,
            notificationContentLabel,
            notificationTimeLabel,
            notificationBadge,
            loadingBackground,
            loadingIndicator
        )
        backgroundColor = .white
        notificationImageView.clipsToBounds = true
        notificationImageView.contentMode = .scaleAspectFill
        notificationImageView.layer.cornerRadius = 12
        
        notificationCategoryLabel.numberOfLines = 1
        notificationContentLabel.numberOfLines = 0
        notificationTimeLabel.numberOfLines = 1
        
        notificationBadge.layer.cornerRadius = 4
        notificationBadge.clipsToBounds = true
        notificationBadge.backgroundColor = UIColor(rgb: 0xFA2C5A)
        
        loadingBackground.backgroundColor = .white
        loadingBackground.alpha = 0
        
        loadingIndicator.style = .medium
        loadingIndicator.color = UIColor(rgb: 0x7126B5)
        
        let margin = contentView.layoutMarginsGuide
        widthNotificationBadgeConstraint = notificationBadge.widthAnchor.constraint(equalToConstant: 8)
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
            notificationContentLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            notificationTimeLabel.topAnchor.constraint(equalTo: notificationImageView.topAnchor),
            notificationTimeLabel.trailingAnchor.constraint(equalTo: notificationBadge.leadingAnchor, constant: -8),
            
            notificationBadge.topAnchor.constraint(equalTo: notificationImageView.topAnchor, constant: 2),
            notificationBadge.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            notificationBadge.heightAnchor.constraint(equalToConstant: 8),
            widthNotificationBadgeConstraint!,
            
            loadingBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loadingBackground.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            loadingBackground.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingBackground.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingBackground.centerYAnchor)
        ])
    }
    
    func fill(with data: SHNotificationResponse) {
        loadingBackground.fadeIn()
        loadingIndicator.startAnimating()
        typealias status = notificationProductStatus
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.notificationImageView.kf.indicatorType = .activity
            if let url = URL(string: data.imageURL) {
                _self.notificationImageView.kf.setImage(
                    with: url,
                    options: [.transition(.fade(0.25))]
                )
            }
            switch data.status {
            case status.accepted.rawValue:
                _self.notificationCategoryLabel.setTitle(
                    text: "Penawaran diterima",
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            case status.bid.rawValue:
                _self.notificationCategoryLabel.setTitle(
                    text: "Penawaran produk",
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            case status.declined.rawValue:
                _self.notificationCategoryLabel.setTitle(
                    text: "Penawaran ditolak",
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            case status.create.rawValue:
                _self.notificationCategoryLabel.setTitle(
                    text: "Produk berhasil diterbitkan",
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            default:
                _self.layoutSubviews()
            }
            
            _self.notificationContentLabel.setTitle(
                text: "\(data.productName )\n\(data.bidPrice?.convertToCurrency() ?? data.product?.productDescription ?? "")",
                size: 14,
                weight: .regular,
                color: .black
            )
            if let _date = data.transactionDate {
                _self.notificationTimeLabel.setTitle(
                    text: _date.convertToDateString(dateFormat: "dd MMM, HH:mm"),
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            }
            if data.read {
                self?.isRead = true
            } else {
                self?.isRead = false
            }
//            if let read = data.read {
//                if read {
//                    self?.isRead = true
//                } else {
//                    self?.isRead = false
//                }
//            }
        }
        loadingIndicator.stopAnimating()
        loadingBackground.fadeOut()
    }
}

