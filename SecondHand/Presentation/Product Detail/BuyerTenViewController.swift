//
//  BuyerTenViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 28/06/22.
//

import UIKit

final class BuyerTenViewController: SHModalViewController {
    
    private lazy var handleBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC4C4C4)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Masukkan Harga Tawarmu"
        label.font = UIFont(name: "Poppins-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Harga tawaranmu akan diketahui penual, jika penjual cocok kamu akan segera dihubungi penjual."
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = UIColor(rgb: 0x8A8A8A)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img-home-product-placeholder-1")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var productName: UILabel = {
        let label = UILabel()
        label.text = "Jam Tangan Casio"
        label.font = UIFont(name: "Poppins-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var productPrice: UILabel = {
        let label = UILabel()
        label.text = "Rp. 250.000"
        label.font = UIFont(name: "Poppins-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var productItem: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var offerLabel: UILabel = {
        let label = UILabel()
        label.text = "Harga Tawar"
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var offerTextfield: SHRoundedTextfield = {
        let textfield = SHRoundedTextfield()
        textfield.setPlaceholder(placeholder: "Rp 0,0")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }()
    
    private lazy var sendButton: SHButton = {
        let button = SHButton(frame: CGRect.zero, title: "Kirim", type: .filled, size: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        defineLayout()
    }
    
    private func setupSubViews() {
        containerView.addSubviews(
            handleBar,
            headerLabel,
            detailLabel,
            productItem,
            offerLabel,
            offerTextfield,
            sendButton
        )
        productItem.addSubviews(
            imageView,
            productName,
            productPrice
        )
    }
    
    private func defineLayout() {
        
        NSLayoutConstraint.activate([
            handleBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            handleBar.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            handleBar.heightAnchor.constraint(equalToConstant: 6),
            handleBar.widthAnchor.constraint(equalToConstant: 60),
            
            headerLabel.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 18),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            
            detailLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            detailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            detailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            productItem.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 16),
            productItem.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            productItem.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            productItem.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            imageView.centerYAnchor.constraint(equalTo: productItem.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: productItem.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: productItem.bottomAnchor, constant: -16),
            imageView.leadingAnchor.constraint(equalTo: productItem.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.heightAnchor.constraint(equalToConstant: 48),
            
            productName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            productName.centerYAnchor.constraint(equalTo: productItem.centerYAnchor, constant: -12),
            
            productPrice.topAnchor.constraint(equalTo: productName.bottomAnchor),
            productPrice.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            
            offerLabel.topAnchor.constraint(equalTo: productItem.bottomAnchor, constant: 24),
            offerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            
            offerTextfield.topAnchor.constraint(equalTo: offerLabel.bottomAnchor),
            offerTextfield.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            offerTextfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            sendButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
        ])
    }
}
