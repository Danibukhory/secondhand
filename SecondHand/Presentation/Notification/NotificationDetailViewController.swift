//
//  NotificationDetailViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 17/07/22.
//

import UIKit

final class NotificationDetailViewController: UITableViewController {
    
    var api = SecondHandAPI.shared
    var notification: SHNotificationResponse
    var product: SHBuyerProductDetailResponse?
    var statusImage: UIImage?
    var contactButton = SHButton(frame: CGRect(), title: "Hubungi", type: .filled, size: .small)
    var offerButton = SHButton(frame: CGRect(), title: "Tawar Lagi", type: .filled, size: .small)
    
    init(notification: SHNotificationResponse, style: UITableView.Style) {
        self.notification = notification
        switch notification.status {
        case "accepted":
            statusImage = UIImage(systemName: "checkmark.bubble.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGreen) ?? UIImage(systemName: "checkmark.bubble.fill")
        case "declined":
            statusImage = UIImage(systemName: "xmark.square.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed) ?? UIImage(systemName: "xmark.square.fill")
        default:
            break
        }
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
        tableView.register(NotificationDetailCell.self, forCellReuseIdentifier: "\(NotificationDetailCell.self)")
        title = "Detail Penawaran"
        loadProduct()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Detail Penjual"
        case 2:
            return "Detail Produk"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
            cell.selectionStyle = .none
            var config = cell.defaultContentConfiguration()
            config.image = statusImage
            if notification.status == "accepted" {
                let string = NSMutableAttributedString(
                    string: "Penawaran anda diterima!",
                    attributes: [.font : UIFont(name: "Poppins-Medium", size: 14)!]
                )
                string.append(NSMutableAttributedString(
                    string: "\nHubungi penjual sekarang atau tunggu penjual untuk menghubungi anda.",
                    attributes: [.font : UIFont(name: "Poppins-Regular", size: 10)!, .foregroundColor : UIColor.secondaryLabel]
                ))
                config.attributedText = string
            } else if notification.status == "declined" {
                let string = NSMutableAttributedString(
                    string: "Penawaran anda ditolak :(",
                    attributes: [.font : UIFont(name: "Poppins-SemiBold", size: 14)!]
                )
                string.append(NSMutableAttributedString(
                    string: "\nCoba ajukan penawaran lagi dengan harga yang lebih baik.",
                    attributes: [.font : UIFont(name: "Poppins-Regular", size: 10)!, .foregroundColor : UIColor.secondaryLabel]
                ))
                config.attributedText = string
            }
            cell.contentConfiguration = config
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NotificationDetailCell.self)", for: indexPath) as? NotificationDetailCell else { return UITableViewCell() }
            if let _product = product {
                cell.fill(with: _product)
            }
            if notification.status == "accepted" {
                cell.contentView.addSubview(contactButton)
                NSLayoutConstraint.activate([
                    contactButton.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
                    contactButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                ])
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NotificationDetailCell.self)", for: indexPath) as? NotificationDetailCell else { return UITableViewCell() }
            cell.fill(with: notification)
            if notification.status == "declined" {
                cell.contentView.addSubview(offerButton)
                NSLayoutConstraint.activate([
                    offerButton.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
                    offerButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                ])
            }
            return cell
        }
        
    }
    
    private func loadProduct() {
        api.getBuyerProductDetail(itemId: "\(notification.productID)") { [weak self] result, error in
            guard let _self = self, let _result = result else {
                return
            }
            _self.product = _result
            _self.tableView.reloadData()
        }
    }
}
