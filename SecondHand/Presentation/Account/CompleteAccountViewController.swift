//
//  CompleteAccountViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 04/07/22.
//

import UIKit
import PhotosUI


final class CompleteAccountViewController: UIViewController {
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    
    private lazy var labelName = SHLabelView(frame: CGRect.zero, title: "Nama*")
    private lazy var labelCity = SHLabelView(frame: CGRect.zero, title: "Kota*")
    private lazy var labelAddress = SHLabelView(frame: CGRect.zero, title: "Alamat*")
    private lazy var labelPhone = SHLabelView(frame: CGRect.zero, title: "No Handphone*")
    
    private lazy var textFieldName = SHRoundedTextfield(frame: CGRect.zero)
    private lazy var textFieldCity = SHDropDownTextField(frame: CGRect.zero)
    private lazy var textFieldAddress = SHLongRoundedTextfield(frame: CGRect.zero)
    private lazy var textFieldPhone: SHRoundedTextfield = {
        let textfield = SHRoundedTextfield(frame: CGRect.zero)
        textfield.keyboardType = .numberPad
        
        return textfield
    }()
    
    private lazy var buttonSave = SHButton(frame: CGRect.zero, title: "Terbitkan", type: .filled, size: .regular)
    private lazy var photosFromLibrary: [UIImageView] = []
    
    private lazy var photoIcon: UIImageView = {
        let photo = UIImage(named: "img-sh-camera")
        let photoView = UIImageView(image: photo)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .center

        return photoView
    }()
    
    private lazy var backgroundProfilePic: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor(rgb: 0xE2D4F0)
        backView.layer.cornerRadius = 12
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImageFromLibrary))
        backView.addGestureRecognizer(tapRecognizer)
        backView.isUserInteractionEnabled = true
        backView.clipsToBounds = true
        backView.translatesAutoresizingMaskIntoConstraints = false
        return backView
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
        self.title = "Lengkapi Info Akun"
        view.backgroundColor = .white
        
        
        setupSubviews()
        defineLayout()
    }
    
    private func setupSubviews() {
        view.addSubviews(scrollView,buttonSave)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubviews(
            backgroundProfilePic,
            labelName,
            labelCity,
            labelAddress,
            labelPhone,
            textFieldName,
            textFieldCity,
            textFieldAddress,
            textFieldPhone
        )
        
        backgroundProfilePic.addSubviews(photoIcon)
                
        textFieldName.setPlaceholder(placeholder: "Nama")
        textFieldCity.setPlaceholder(placeholder: "Pilih Kota")
        textFieldPhone.setPlaceholder(placeholder: "contoh: +628123456789")
        
        
        let getData = DataForCityInIndonesia()
        textFieldCity.optionArray = getData.dataKotaBersih
        textFieldCity.arrowColor = UIColor(rgb: 0x8A8A8A)
        
    
        
        buttonSave.addTarget(self, action: #selector(publishButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func publishButtonTapped() {

        if (textFieldName.text?.isEmpty == true) {
            textFieldName.layer.borderColor = UIColor.red.cgColor
            textFieldName.layer.borderWidth = 1
        }
        if (textFieldCity.text?.isEmpty == true) {
            textFieldCity.layer.borderColor = UIColor.red.cgColor
            textFieldCity.layer.borderWidth = 1
        }
        if (textFieldAddress.text == "Contoh: Jalan Ikan Hiu 33") {
            textFieldAddress.layer.borderColor = UIColor.red.cgColor
            textFieldAddress.layer.borderWidth = 1
        }
        if (textFieldPhone.text?.isEmpty == true) {
            textFieldPhone.layer.borderColor = UIColor.red.cgColor
            textFieldPhone.layer.borderWidth = 1
        }
        if (textFieldName.text?.isEmpty == false), (textFieldCity.text?.isEmpty == false), (textFieldAddress.text?.isEmpty == false), (textFieldPhone.text?.isEmpty == false), (photosFromLibrary.count > 0) {

            DispatchQueue.main.async {
                let callAPI = SecondHandAPI()
                callAPI.putAccountDetail(with: self.textFieldName.text!,
                                         city: self.textFieldCity.text!,
                                         phoneNumber: Int(self.textFieldPhone.text!)!,
                                         address: self.textFieldAddress.text!,
                                         accountPicture: self.photosFromLibrary[0].image!)
            }
        }
    }
    
    private func defineLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        textFieldCity.translatesAutoresizingMaskIntoConstraints = false
        textFieldAddress.translatesAutoresizingMaskIntoConstraints = false
        textFieldPhone.translatesAutoresizingMaskIntoConstraints = false
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
//            containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        let margin = containerView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            backgroundProfilePic.topAnchor.constraint(equalTo: margin.topAnchor, constant: 24),
            backgroundProfilePic.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            backgroundProfilePic.widthAnchor.constraint(equalToConstant: 96),
            backgroundProfilePic.heightAnchor.constraint(equalToConstant: 96),
            
            photoIcon.centerXAnchor.constraint(equalTo: backgroundProfilePic.centerXAnchor),
            photoIcon.centerYAnchor.constraint(equalTo: backgroundProfilePic.centerYAnchor),
            photoIcon.topAnchor.constraint(equalTo: backgroundProfilePic.topAnchor),
            photoIcon.bottomAnchor.constraint(equalTo: backgroundProfilePic.bottomAnchor),
            photoIcon.leadingAnchor.constraint(equalTo: backgroundProfilePic.leadingAnchor),
            photoIcon.trailingAnchor.constraint(equalTo: backgroundProfilePic.trailingAnchor),
            
            labelName.topAnchor.constraint(equalTo: backgroundProfilePic.bottomAnchor, constant: 24),
            labelName.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor),
            textFieldName.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            textFieldName.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            labelCity.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 24),
            labelCity.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
//            labelCity.heightAnchor.constraint(equalToConstant: 18),
            
            textFieldCity.topAnchor.constraint(equalTo: labelCity.bottomAnchor),
            textFieldCity.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            textFieldCity.trailingAnchor.constraint(equalTo: margin.trailingAnchor),

            
            labelAddress.topAnchor.constraint(equalTo: textFieldCity.bottomAnchor, constant: 24),
            labelAddress.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            textFieldAddress.topAnchor.constraint(equalTo: labelAddress.bottomAnchor),
            textFieldAddress.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            textFieldAddress.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            labelPhone.topAnchor.constraint(equalTo: textFieldAddress.bottomAnchor, constant: 24),
            labelPhone.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            textFieldPhone.topAnchor.constraint(equalTo: labelPhone.bottomAnchor),
            textFieldPhone.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            textFieldPhone.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            textFieldPhone.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -96),
            
            buttonSave.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            buttonSave.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            buttonSave.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        
        ])
        
        for photoFromLibrary in photosFromLibrary {
            photoFromLibrary.translatesAutoresizingMaskIntoConstraints = false
            
            backgroundProfilePic.addSubviews(photoFromLibrary)
            
            NSLayoutConstraint.activate([
                photoFromLibrary.topAnchor.constraint(equalTo: backgroundProfilePic.topAnchor),
                photoFromLibrary.bottomAnchor.constraint(equalTo: backgroundProfilePic.bottomAnchor),
                photoFromLibrary.leadingAnchor.constraint(equalTo: backgroundProfilePic.leadingAnchor),
                photoFromLibrary.trailingAnchor.constraint(equalTo: backgroundProfilePic.trailingAnchor)
            ])
        }
    }
    
}

extension CompleteAccountViewController: PHPickerViewControllerDelegate {
    
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
