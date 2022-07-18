//
//  OfferAcceptedViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 22/06/22.
//

import UIKit

final class AcceptedOfferViewController: SHModalViewController {
    
    var handleBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC4C4C4)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle(
            text: "Yeay! Kamu berhasil dapat harga yang sesuai!",
            size: 14,
            weight: .medium,
            color: .black
        )
        label.numberOfLines = 0
        return label
    }()
    
    var instructionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitle(
            text: "Segera hubungi pembeli melalui WhatsApp untuk transaksi selanjutnya.",
            size: 14,
            weight: .regular,
            color: UIColor(rgb: 0x8A8A8A)
        )
        label.numberOfLines = 0
        return label
    }()
    
    var productMatchBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    
    var productMatchLabel: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.setTitle(
             text: "Product Match",
             size: 14,
             weight: .medium,
             color: .black
         )
         label.numberOfLines = 0
         return label
    }()
    
    var buyerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var buyerNameLabel: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         return label
    }()
    
    var buyerCityLabel: UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         return label
    }()
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var productNameLabel: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         return label
    }()
    
    var productValueLabel: UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 1
         return label
    }()
    
    var contactBuyerButton: SHButton = {
        let button = SHButton(frame: CGRect(), title: "Hubungi Via WhatsApp", type: .filled, size: .regular)
        let whatsappImageView = UIImageView()
        button.addSubview(whatsappImageView)
        whatsappImageView.translatesAutoresizingMaskIntoConstraints = false
        whatsappImageView.image = UIImage(named: "img-sh-whatsapp")
        
        NSLayoutConstraint.activate([
            whatsappImageView.widthAnchor.constraint(equalToConstant: 16),
            whatsappImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            whatsappImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -24)
        ])
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        defineLayout()
    }
    
    func addSubviews() {
        containerView.addSubviews(handleBar, greetingLabel, instructionLabel, productMatchBorderView, contactBuyerButton)
        productMatchBorderView.addSubviews(productMatchLabel, buyerImageView, buyerNameLabel, buyerCityLabel, productImageView, productNameLabel, productValueLabel)
    }
    
    func defineLayout() {
        let margin = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            handleBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            handleBar.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            handleBar.heightAnchor.constraint(equalToConstant: 6),
            handleBar.widthAnchor.constraint(equalToConstant: 60),
            
            greetingLabel.topAnchor.constraint(equalTo: handleBar.bottomAnchor, constant: 16),
            greetingLabel.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            instructionLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            instructionLabel.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: greetingLabel.leadingAnchor),
            instructionLabel.trailingAnchor.constraint(equalTo: greetingLabel.trailingAnchor),
            
            productMatchBorderView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16),
            productMatchBorderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 64),
            productMatchBorderView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            productMatchBorderView.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            
            productMatchLabel.topAnchor.constraint(equalTo: productMatchBorderView.topAnchor, constant: 16),
            productMatchLabel.centerXAnchor.constraint(equalTo: productMatchBorderView.centerXAnchor),
            
            buyerImageView.topAnchor.constraint(equalTo: productMatchLabel.bottomAnchor, constant: 16),
            buyerImageView.leadingAnchor.constraint(equalTo: productMatchBorderView.leadingAnchor, constant: 16),
            buyerImageView.heightAnchor.constraint(equalToConstant: 48),
            buyerImageView.widthAnchor.constraint(equalTo: buyerImageView.heightAnchor),
            
            buyerNameLabel.leadingAnchor.constraint(equalTo: buyerImageView.trailingAnchor, constant: 16),
            buyerNameLabel.centerYAnchor.constraint(equalTo: buyerImageView.centerYAnchor, constant: -10),
            buyerNameLabel.trailingAnchor.constraint(equalTo: productMatchBorderView.trailingAnchor, constant: 16),
            
            buyerCityLabel.topAnchor.constraint(equalTo: buyerNameLabel.bottomAnchor),
            buyerCityLabel.leadingAnchor.constraint(equalTo: buyerNameLabel.leadingAnchor),
            buyerCityLabel.trailingAnchor.constraint(equalTo: buyerNameLabel.trailingAnchor),
            
            productImageView.topAnchor.constraint(equalTo: buyerImageView.bottomAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: buyerImageView.leadingAnchor),
            productImageView.heightAnchor.constraint(equalTo: buyerImageView.heightAnchor),
            productImageView.widthAnchor.constraint(equalTo: buyerImageView.heightAnchor),
            
            productNameLabel.leadingAnchor.constraint(equalTo: buyerImageView.trailingAnchor, constant: 16),
            productNameLabel.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor, constant: -10),
            productNameLabel.trailingAnchor.constraint(equalTo: buyerNameLabel.trailingAnchor),
            
            productValueLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            productValueLabel.leadingAnchor.constraint(equalTo: buyerNameLabel.leadingAnchor),
            productValueLabel.trailingAnchor.constraint(equalTo: buyerNameLabel.trailingAnchor),
            productValueLabel.bottomAnchor.constraint(equalTo: productMatchBorderView.bottomAnchor, constant: -16),
            
            contactBuyerButton.widthAnchor.constraint(equalTo: productMatchBorderView.widthAnchor),
            contactBuyerButton.topAnchor.constraint(equalTo: productMatchBorderView.bottomAnchor, constant: 24),
            contactBuyerButton.heightAnchor.constraint(equalToConstant: 48),
            contactBuyerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
   
}
