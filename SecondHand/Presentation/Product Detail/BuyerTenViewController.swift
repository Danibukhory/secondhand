//
//  BuyerTenViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 28/06/22.
//

import UIKit
import Kingfisher

//protocol ItemIsOfferedDelegate: AnyObject {
//    func userDidOfferItem(info:Bool, code:Int?)
//}

final class BuyerTenViewController: SHModalViewController {
    
//    weak var delegate: ItemIsOfferedDelegate? = nil
    var buyerResponse: SHBuyerProductResponse?
    var typedOfferValue: String = ""
    
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
        label.text = "Harga tawaranmu akan diketahui penjual, jika penjual cocok kamu akan segera dihubungi penjual."
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = UIColor(rgb: 0x8A8A8A)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let url = URL(string: buyerResponse?.imageURL ?? "")
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var productName: UILabel = {
        let label = UILabel()
        label.text = buyerResponse?.name
        label.font = UIFont(name: "Poppins-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var productPrice: UILabel = {
        let label = UILabel()
        label.text = (buyerResponse?.basePrice ?? 0).convertToCurrency()
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
        textfield.keyboardType = .numberPad
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.returnKeyType = .done
//        textfield.addTarget(self, action: #selector(onBidValueEdited), for: .editingChanged)
        textfield.addTarget(self, action: #selector(onBidValueEndEditing), for: .editingDidEnd)
        textfield.addTarget(self, action: #selector(onBidValueBeginEditing), for: .editingDidBegin)
        return textfield
    }()
    
    private lazy var sendButton: SHButton = {
        let button = SHButton(frame: CGRect.zero, title: "Kirim", type: .filled, size: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    typealias OnSendButtonTapped = (Int) -> Void
    var onSendButtonTapped: OnSendButtonTapped?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        defineLayout()
    }
    
    override func animateDismissView() {
        super.animateDismissView()
        self.sendButton.fadeOut()
        self.containerView.endEditing(true)
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
    
    override func handlePanGesture(gesture: UIPanGestureRecognizer) {
        super.handlePanGesture(gesture: gesture)
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .changed:
            sendButton.alpha = ((currentContainerHeight ?? 0) - (translation.y * 1.5)) / defaultHeight
        case .ended:
            if (currentContainerHeight ?? 0) <= dismissibleHeight {
                sendButton.fadeOut()
            } else {
                sendButton.fadeIn()
            }
        default:
            break
        }
    }
    
    private func defineLayout() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.containerView.addGestureRecognizer(tapRecognizer)
        self.containerView.isUserInteractionEnabled = true
        offerTextfield.addTarget(self, action: #selector(maximizeHeight), for: .editingDidBegin)
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
            
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sendButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
        ])
    }
    
    @objc private func maximizeHeight() {
        self.animateContainerHeight(self.maximumContainerHeight)
    }
    
    @objc private func dismissKeyboard() {
        self.containerView.endEditing(true)
        self.animateContainerHeight(self.defaultHeight)
    }
    
    @objc private func sendButtonTapped() {
        onSendButtonTapped?(Int(typedOfferValue) ?? 0)
        self.animateDismissView()
    }
    
    @objc private func onBidValueBeginEditing() {
        offerTextfield.text = typedOfferValue
        sendButton.isEnabled = false
    }
    
//    @objc private func onBidValueEdited() {
//        if let text = offerTextfield.text, !text.isEmpty {
//            sendButton.isEnabled = true
//        } else {
//            sendButton.isEnabled = false
//        }
//    }
    
    @objc private func onBidValueEndEditing() {
        if let text = offerTextfield.text, !text.isEmpty {
            offerTextfield.text = text.convertToCurrency()
            typedOfferValue = text
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
}
