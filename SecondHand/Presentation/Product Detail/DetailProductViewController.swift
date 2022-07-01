//
//  DetailProductViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 30/06/22.
//

import UIKit
import PhotosUI


final class DetailProductViewController: UIViewController {
    private lazy var scrollView = UIScrollView()
    private lazy var category: Int = 0
    
    private lazy var productName = SHLabelView(frame: CGRect.zero, title: "Nama Produk")
    private lazy var productPrice = SHLabelView(frame: CGRect.zero, title: "Harga Produk")
    private lazy var categoryLabel = SHLabelView(frame: CGRect.zero, title: "Kategori")
    private lazy var descLabel = SHLabelView(frame: CGRect.zero, title: "Deskripsi")
    private lazy var productPhoto = SHLabelView(frame: CGRect.zero, title: "Foto Produk")
    
    private lazy var nameTextfield = SHRoundedTextfield(frame: CGRect.zero)
    private lazy var categoryDropdown = SHDropDownTextField(frame: CGRect.zero)
    private lazy var descTextfield = SHLongRoundedTextfield(frame: CGRect.zero)
    private lazy var priceTextfield: SHRoundedTextfield = {
        let textfield = SHRoundedTextfield(frame: CGRect.zero)
        textfield.keyboardType = .numberPad
        
        return textfield
    }()
    
    private lazy var buttonPreview = SHButton(frame: CGRect.zero, title: "Preview", type: .bordered, size: .regular)
    private lazy var buttonPublish = SHButton(frame: CGRect.zero, title: "Terbitkan", type: .filled, size: .regular)
    private lazy var photosFromLibrary: [UIImageView] = []
    
    private lazy var photoIcon: UIImageView = {
        let photo = UIImage(named: "img-sh-plus")
        let photoView = UIImageView(image: photo)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .center

        return photoView
    }()

    private lazy var dashedView: UIView = {
        let color = UIColor(rgb: 0xD0D0D0).cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = 96
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize, height: frameSize)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize/2, y: frameSize/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        let shapeView = UIView()
        shapeView.layer.addSublayer(shapeLayer)
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImageFromLibrary))
        shapeView.addGestureRecognizer(tapRecognizer)
        shapeView.isUserInteractionEnabled = true
        shapeView.clipsToBounds = true
        shapeView.layer.cornerRadius = 12
        
        return shapeView
    }()
    
    @objc func pickImageFromLibrary() {
        lazy var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        lazy var pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lengkapi Detail Produk"
        view.backgroundColor = .white
        
        setupSubviews()
        defineLayout()
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubviews(
            productName,
            productPrice,
            categoryLabel,
            descLabel,
            productPhoto,
            nameTextfield,
            priceTextfield,
            categoryDropdown,
            descTextfield,
            dashedView,
            buttonPreview,
            buttonPublish
        )
        
        dashedView.addSubviews(photoIcon)
        
        nameTextfield.setPlaceholder(placeholder: "Nama Produk")
        priceTextfield.setPlaceholder(placeholder: "Rp 0,00")

        categoryDropdown.setPlaceholder(placeholder: "Pilih Kategori")
        categoryDropdown.arrowColor = UIColor(rgb: 0x8A8A8A)
        categoryDropdown.optionArray = ["Hobi", "Aksesoris", "Kendaraan"]
        categoryDropdown.optionIds = [1,2,3]
        categoryDropdown.didSelect { selectedText, index, id in
            self.category = id
        }
    
        
        buttonPublish.addTarget(self, action: #selector(publishButtonTapped), for: .touchUpInside)
        buttonPreview.addTarget(self, action: #selector(publishButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func publishButtonTapped() {
//        if ((nameTextfield.text?.isEmpty) != nil), ((priceTextfield.text?.isEmpty) != nil), ((descTextfield.text?.isEmpty) != nil), ((categoryDropdown.text?.isEmpty) != nil) {}
        if (nameTextfield.text?.isEmpty == true) {
            nameTextfield.layer.borderColor = UIColor.red.cgColor
            nameTextfield.layer.borderWidth = 1
        }
        if (priceTextfield.text?.isEmpty == true) {
            priceTextfield.layer.borderColor = UIColor.red.cgColor
            priceTextfield.layer.borderWidth = 1
        }
        if (descTextfield.text == "Contoh: Jalan Ikan Hiu 33") {
            descTextfield.layer.borderColor = UIColor.red.cgColor
            descTextfield.layer.borderWidth = 1
        }
        if (categoryDropdown.text?.isEmpty == true) {
            categoryDropdown.layer.borderColor = UIColor.red.cgColor
            categoryDropdown.layer.borderWidth = 1
        }
        if (nameTextfield.text?.isEmpty == false), (priceTextfield.text?.isEmpty == false), (descTextfield.text?.isEmpty == false), (categoryDropdown.text?.isEmpty == false), (photosFromLibrary.count > 0) {

            DispatchQueue.main.async {
                let callAPI = SecondHandAPI()
                callAPI.postProductAsSeller(
                    with: self.nameTextfield.text!,
                    description: self.descTextfield.text!,
                    basePrice: Int(self.priceTextfield.text!)!,
                    category: self.category,
                    location: "Jakarta",
                    productPicture: self.photosFromLibrary[0].image!)
            }
        }
    }
    
    private func defineLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        nameTextfield.translatesAutoresizingMaskIntoConstraints = false
        priceTextfield.translatesAutoresizingMaskIntoConstraints = false
        categoryDropdown.translatesAutoresizingMaskIntoConstraints = false
        descTextfield.translatesAutoresizingMaskIntoConstraints = false
        buttonPreview.translatesAutoresizingMaskIntoConstraints = false
        buttonPublish.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let margin = scrollView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            productName.topAnchor.constraint(equalTo: margin.topAnchor),
            productName.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            nameTextfield.topAnchor.constraint(equalTo: productName.bottomAnchor),
            nameTextfield.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            nameTextfield.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            productPrice.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor, constant: 16),
            productPrice.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            priceTextfield.topAnchor.constraint(equalTo: productPrice.bottomAnchor),
            priceTextfield.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            priceTextfield.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: priceTextfield.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            categoryDropdown.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
            categoryDropdown.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            categoryDropdown.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            descLabel.topAnchor.constraint(equalTo: categoryDropdown.bottomAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            descTextfield.topAnchor.constraint(equalTo: descLabel.bottomAnchor),
            descTextfield.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            descTextfield.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            productPhoto.topAnchor.constraint(equalTo: descTextfield.bottomAnchor, constant: 16),
            productPhoto.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            dashedView.topAnchor.constraint(equalTo: productPhoto.bottomAnchor),
            dashedView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            dashedView.widthAnchor.constraint(equalToConstant: 96),
            dashedView.heightAnchor.constraint(equalToConstant: 96),
            
            photoIcon.centerXAnchor.constraint(equalTo: dashedView.centerXAnchor),
            photoIcon.centerYAnchor.constraint(equalTo: dashedView.centerYAnchor),
            
            buttonPreview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            buttonPreview.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            buttonPreview.widthAnchor.constraint(equalTo: buttonPublish.widthAnchor),
            
            buttonPublish.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            buttonPublish.leadingAnchor.constraint(equalTo: buttonPreview.trailingAnchor, constant: 16),
            buttonPublish.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
        ])
        
        for photoFromLibrary in photosFromLibrary {
            photoFromLibrary.translatesAutoresizingMaskIntoConstraints = false
            
            dashedView.addSubviews(photoFromLibrary)
            
            NSLayoutConstraint.activate([
                photoFromLibrary.topAnchor.constraint(equalTo: dashedView.topAnchor),
                photoFromLibrary.bottomAnchor.constraint(equalTo: dashedView.bottomAnchor),
                photoFromLibrary.leadingAnchor.constraint(equalTo: dashedView.leadingAnchor),
                photoFromLibrary.trailingAnchor.constraint(equalTo: dashedView.trailingAnchor)
            ])
        }
    }
    
}

extension DetailProductViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results[0].itemProvider.loadObject(ofClass: UIImage.self) {[weak self] reading, error in
            if let image = reading as? UIImage {
                DispatchQueue.main.async {
                    let imv = self?.newImageView(image: image)
                    self?.photosFromLibrary.append(imv!)
                    self?.defineLayout()
                    self?.view.setNeedsLayout()
                }
            }
        }
    }
    
    func newImageView(image:UIImage?) -> UIImageView {
        let imv = UIImageView()
        imv.backgroundColor = .clear
        imv.image = image
        imv.layer.cornerRadius = 12
        return imv
    }
}

final class SHLabelView: UILabel {
    init(frame: CGRect, title name: String) {
        super.init(frame: frame)
        self.text = name
        self.font = UIFont(name: "Poppins-Regular", size: 12)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
