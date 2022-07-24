//
//  SellerCardTableViewCell.swift
//  SecondHand
//
//  Created by Daffashiddiq on 20/07/22.
//

import UIKit


final class SellerCardCell: UITableViewCell {
    
    typealias DidClickedEditButtonAction = () -> Void
    var didClickedEditButtonAction: DidClickedEditButtonAction?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var topContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 1.8
        return containerView
    }()
    private lazy var imageTopView: UIImageView = {
        let imageTop = UIImageView()
        imageTop.translatesAutoresizingMaskIntoConstraints = false
        imageTop.backgroundColor = UIColor.systemGray
        imageTop.layer.cornerRadius = 12
        imageTop.clipsToBounds = true
        return imageTop
    }()
    private lazy var sellerNameLabel: UILabel = {
       let sellerName = UILabel()
        sellerName.translatesAutoresizingMaskIntoConstraints = false
        sellerName.text = "Nama Penjual"
        sellerName.font = UIFont(name: "Poppins-SemiBold", size: 14)
        return sellerName
    }()
    private lazy var sellerCityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.text = "Kota"
        cityLabel.font = UIFont(name: "Poppins-Light", size: 10)
        return cityLabel
    }()
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(rgb: 0x7126B5).cgColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        let attributedTitle = NSAttributedString(
            string: "Edit",
            attributes: [.font : UIFont(name: "Poppins-Regular", size: 12)!]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(didClickedEditButton), for: .touchUpInside)
        return button
    }()
}

extension SellerCardCell {
    @objc private func didClickedEditButton() {
        didClickedEditButtonAction?()
    }
    func fill(userDetails data: SHUserResponse?) {
        let urlString = data?.imageURL
        if let url = URL(string: urlString ?? "") {
            imageTopView.kf.indicatorType = .activity
            imageTopView.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage])
        } else {
            imageTopView.image = UIImage(named: "img-sh-user-active")
            imageTopView.contentMode = .scaleAspectFill
        }
        
        if let name = data?.fullName {
            self.sellerNameLabel.text = name
        } else {
            self.sellerNameLabel.text = "Nama tidak tersedia"
        }
        
        if !(data?.city!.isEmpty)! {
            self.sellerCityLabel.text = data?.city!
        } else {
            self.sellerCityLabel.text = "Kota tidak tersedia"
        }
    }
    private func setupView() {
        contentView.addSubviews(
            topContainerView,
            imageTopView,
            sellerNameLabel,
            sellerCityLabel,
            editButton
        )
    }
    private func setupConstraint() {
        let margin = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: margin.topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            topContainerView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
            imageTopView.centerYAnchor.constraint(equalTo: margin.centerYAnchor),
            imageTopView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 16),
            imageTopView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 16),
            imageTopView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -16),
            imageTopView.widthAnchor.constraint(equalToConstant: 48),
            imageTopView.heightAnchor.constraint(equalToConstant: 48),
            
            sellerNameLabel.leadingAnchor.constraint(equalTo: imageTopView.trailingAnchor, constant: 16),
            sellerNameLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -16),
            sellerNameLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor, constant: -10),
            
            sellerCityLabel.topAnchor.constraint(equalTo: sellerNameLabel.bottomAnchor),
            sellerCityLabel.leadingAnchor.constraint(equalTo: imageTopView.trailingAnchor, constant: 16),
            
            editButton.centerYAnchor.constraint(equalTo: margin.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -16),
            
            
        ])
    }
}

