//
//  DetailProductViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 30/06/22.
//

import UIKit
import PhotosUI

final class DetailProductViewController: UIViewController {
        
    private var userResponse: SHUserResponse?
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    private lazy var categoryName: String = ""
    private lazy var category: Int = 0
    private lazy var apiCall = SecondHandAPI()
    
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
        setupTapRecognizer()
        self.title = "Lengkapi Detail Produk"
        self.navigationController?.isNavigationBarHidden = false

        view.backgroundColor = .white
        getUserData { response in
            self.userResponse = response
        }
        setupNavigationBar()
        setupSubviews()
        defineLayout()
    }
    
    private func setupSubviews() {
        view.addSubviews(scrollView,
                         buttonPreview,
                         buttonPublish)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubviews(
            productName,
            productPrice,
            categoryLabel,
            descLabel,
            productPhoto,
            nameTextfield,
            priceTextfield,
            categoryDropdown,
            descTextfield,
            dashedView
        )
        
        dashedView.addSubviews(photoIcon)
        
        nameTextfield.setPlaceholder(placeholder: "Nama Produk")
        priceTextfield.setPlaceholder(placeholder: "Rp 0,00")

        categoryDropdown.setPlaceholder(placeholder: "Pilih Kategori")
        categoryDropdown.arrowColor = UIColor(rgb: 0x8A8A8A)
        getCategories()
        categoryDropdown.didSelect { selectedText, index, id in
            self.categoryName = selectedText
            self.category = id
        }
    
        buttonPreview.backgroundColor = .white
        buttonPublish.addTarget(self, action: #selector(publishButtonTapped), for: .touchUpInside)
        buttonPreview.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        
    }
    
    private func getUserData(completion: @escaping ((SHUserResponse) -> ())) {
        let apiCall = SecondHandAPI()
        let group = DispatchGroup()
        var userResponse: SHUserResponse? = nil
        defer {
            group.notify(queue: .main) {
                completion(userResponse!)
            }
        }
        group.enter()
        apiCall.getUserDetails { data, error in
            userResponse = data
            group.leave()
        }
    }
    
    private func getCategories() {
    
        apiCall.getProductCategories { responses, error in
            var listName: [String] = []
            var listInd: [Int] = []
            for response in responses ?? [] {
                listName.append(response.name!)
                listInd.append(response.id!)
            }
            self.categoryDropdown.optionArray = listName
            self.categoryDropdown.optionIds = listInd
        }
    }
    
    @objc private func previewButtonTapped() {
        if (nameTextfield.text?.isEmpty == true) {
            nameTextfield.layer.borderColor = UIColor.systemRed.cgColor
            nameTextfield.layer.borderWidth = 1
        }
        if (priceTextfield.text?.isEmpty == true) {
            priceTextfield.layer.borderColor = UIColor.systemRed.cgColor
            priceTextfield.layer.borderWidth = 1
        }
        if (descTextfield.text == "Contoh: Jalan Ikan Hiu 33") {
            descTextfield.layer.borderColor = UIColor.systemRed.cgColor
            descTextfield.layer.borderWidth = 1
        }
        if (categoryDropdown.text?.isEmpty == true) {
            categoryDropdown.layer.borderColor = UIColor.systemRed.cgColor
            categoryDropdown.layer.borderWidth = 1
        }
        
        if (nameTextfield.text?.isEmpty == false), (priceTextfield.text?.isEmpty == false), (descTextfield.text?.isEmpty == false), (categoryDropdown.text?.isEmpty == false), (photosFromLibrary.count > 0) {

            let previewViewController = SellerPreviewViewController()
            previewViewController.imageData = self.photosFromLibrary[0].image
            previewViewController.productName = self.nameTextfield.text!
            previewViewController.productPrice = self.priceTextfield.text!
            previewViewController.productDesc = self.descTextfield.text!
            previewViewController.productCategory = self.categoryName
            previewViewController.productCategoryID = self.category
            previewViewController.userResponse = self.userResponse!
            
            previewViewController.modalPresentationStyle = .overCurrentContext
            self.present(previewViewController, animated: true)
        }
        
    }
    
    @objc func publishButtonTapped() {
        if (nameTextfield.text?.isEmpty == true) {
            nameTextfield.layer.borderColor = UIColor.systemRed.cgColor
            nameTextfield.layer.borderWidth = 1
        }
        if (priceTextfield.text?.isEmpty == true) {
            priceTextfield.layer.borderColor = UIColor.systemRed.cgColor
            priceTextfield.layer.borderWidth = 1
        }
        if (descTextfield.text == "Contoh: Jalan Ikan Hiu 33") {
            descTextfield.layer.borderColor = UIColor.systemRed.cgColor
            descTextfield.layer.borderWidth = 1
        }
        if (categoryDropdown.text?.isEmpty == true) {
            categoryDropdown.layer.borderColor = UIColor.systemRed.cgColor
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
                    location: (self.userResponse?.city)!,
                    productPicture: self.photosFromLibrary[0].image!)
            }
            
            let vc = SellingListPageViewController()
            vc.isPopUpEnabled = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func defineLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameTextfield.translatesAutoresizingMaskIntoConstraints = false
        priceTextfield.translatesAutoresizingMaskIntoConstraints = false
        categoryDropdown.translatesAutoresizingMaskIntoConstraints = false
        descTextfield.translatesAutoresizingMaskIntoConstraints = false
        buttonPreview.translatesAutoresizingMaskIntoConstraints = false
        buttonPublish.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        let margin = containerView.layoutMarginsGuide
        
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
            dashedView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -96),
            
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
    
    private func setupNavigationBar() {
        title = "Lengkapi Detail Produk"
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissView))
        button.tintColor = .black
        navigationItem.leftBarButtonItem = button
        navigationController?.navigationBar.useSHTitle()
    }
    
    @objc private func dismissView() {
        self.navigationController?.dismiss(animated: true)
    }
    
    private func setupTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension DetailProductViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) {[weak self] reading, error in
                guard let _self = self else { return }
                if let image = reading as? UIImage {
                    DispatchQueue.main.async {
                        let imv = _self.newImageView(image: image)
                        _self.photosFromLibrary.append(imv)
                        _self.defineLayout()
                        _self.view.setNeedsLayout()
                    }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

