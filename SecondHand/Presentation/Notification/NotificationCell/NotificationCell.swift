//
//  NotificationCell.swift
//  SecondHand
//
//  Created by Bagas Ilham on 16/06/22.
//

import UIKit
import Kingfisher

final class NotificationCell: UITableViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        loadingBackground.fadeOut()
//        loadingIndicator.stopAnimating()
    }
    
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
        
//        loadingIndicator.hidesWhenStopped = true
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
        DispatchQueue.main.async { [self] in
            if let url = URL(string: data.imageURL ?? "") {
                notificationImageView.kf.setImage(
                    with: url,
                    options: [.transition(.fade(0.25)), .cacheOriginalImage]
                )
                notificationImageView.kf.indicatorType = .activity
            }
            switch data.status {
            case "accepted":
                notificationCategoryLabel.setTitle(
                    text: "Penawaran diterima",
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            case "bid":
                notificationCategoryLabel.setTitle(
                    text: "Penawaran produk",
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            case "declined":
                notificationCategoryLabel.setTitle(
                    text: "Penawaran ditolak",
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            case "create":
                notificationCategoryLabel.setTitle(
                    text: "Produk berhasil diterbitkan",
                    size: 10,
                    weight: .regular,
                    color: UIColor(rgb: 0x8A8A8A)
                )
            default:
                layoutSubviews()
            }
            
//            notificationCategoryLabel.setTitle(
//                text: data.status ?? "Status not available",
//                size: 10,
//                weight: .regular,
//                color: UIColor(rgb: 0x8A8A8A)
//            )
            
            notificationContentLabel.setTitle(
                text: "\(data.productName ?? "product has no name")\n\(data.bidPrice?.convertToCurrency() ?? data.product?.description ?? "")",
                size: 14,
                weight: .regular,
                color: .black
            )
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.timeZone = .autoupdatingCurrent
            var date: Date?
            if data.transactionDate != nil {
                date = dateFormatter.date(from: String(data.transactionDate!.prefix(19)))
            }
            let dateStringFormatter = DateFormatter()
            dateStringFormatter.dateFormat = "dd MMM, HH:mm"
            let dateString = dateStringFormatter.string(from: date ?? Date())
            notificationTimeLabel.setTitle(
                text: dateString,
                size: 10,
                weight: .regular,
                color: UIColor(rgb: 0x8A8A8A)
            )
        }
        loadingIndicator.stopAnimating()
        loadingBackground.fadeOut()
    }
}

