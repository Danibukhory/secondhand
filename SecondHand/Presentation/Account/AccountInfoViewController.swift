//
//  AccountInfoViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 15/06/22.
//

import UIKit
import iOSDropDown
import Photos
import PhotosUI

final class AccountInfoViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Lengkapi Info Akun"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 14)!]
        
        tableView.register(ProfilePicViewCell.self, forCellReuseIdentifier: "\(ProfilePicViewCell.self)")
        tableView.register(NameTextFieldViewCell.self, forCellReuseIdentifier: "\(NameTextFieldViewCell.self)")
        tableView.register(KotaTextFieldViewCell.self, forCellReuseIdentifier: "\(KotaTextFieldViewCell.self)")
        tableView.register(AlamatTextField.self, forCellReuseIdentifier: "\(AlamatTextField.self)")
        tableView.register(NomorTextField.self, forCellReuseIdentifier: "\(NomorTextField.self)")
        tableView.register(SimpanButton.self, forCellReuseIdentifier: "\(SimpanButton.self)")
        
        tableView.separatorStyle = .none
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProfilePicViewCell.self)", for: indexPath) as? ProfilePicViewCell else {
                return UITableViewCell()
            }
            cell.viewController = self
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "\(NameTextFieldViewCell.self)", for: indexPath) as? NameTextFieldViewCell else {
                return UITableViewCell()
            }
            cell2.selectionStyle = .none
            return cell2
        
        case 2:
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "\(KotaTextFieldViewCell.self)", for: indexPath) as? KotaTextFieldViewCell else {
                return UITableViewCell()
            }
            cell3.selectionStyle = .none

            return cell3
        case 3:
            guard let cell4 = tableView.dequeueReusableCell(withIdentifier: "\(AlamatTextField.self)", for: indexPath) as? AlamatTextField else {
                return UITableViewCell()
            }
            cell4.selectionStyle = .none

            return cell4
            
        case 4:
            guard let cell5 = tableView.dequeueReusableCell(withIdentifier: "\(NomorTextField.self)", for: indexPath) as? NomorTextField else {
                return UITableViewCell()
            }
            cell5.selectionStyle = .none

            return cell5
            
        case 5:
            guard let cell6 = tableView.dequeueReusableCell(withIdentifier: "\(SimpanButton.self)", for: indexPath) as? SimpanButton else {
                return UITableViewCell()
            }
            cell6.selectionStyle = .none

            return cell6
                
        default:
            return UITableViewCell()
        }
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}

final class ProfilePicViewCell: UITableViewCell, PHPickerViewControllerDelegate {
    
    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    var photosFromLibrary:[UIImageView] = []

    private lazy var backgroundProfilePic: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor(rgb: 0xE2D4F0)
        backView.layer.cornerRadius = 12
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImageFromLibrary))
        backView.addGestureRecognizer(tapRecognizer)
        backView.isUserInteractionEnabled = true
        return backView
    }()
    
    @objc func pickImageFromLibrary() {
        lazy var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        lazy var pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        viewController?.present(pickerVC, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results[0].itemProvider.loadObject(ofClass: UIImage.self) {[weak self] reading, error in
            if let image = reading as? UIImage {
                DispatchQueue.main.async {
                    let imv = self?.newImageView(image: image)
                    self?.photosFromLibrary.append(imv!)
                    self?.backgroundProfilePic.bringSubviewToFront(imv!)
                    self?.viewController?.view.setNeedsLayout()
                    self?.defineLayout()
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
    
    private lazy var photoIcon: UIImageView = {
        let photo = UIImage(named: "img-sh-camera")
        let photoView = UIImageView(image: photo)
        return photoView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
        defineLayout()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    private func defineLayout() {
        let margin = contentView.layoutMarginsGuide
//        if !isImageExist {
        contentView.addSubviews(backgroundProfilePic)
        backgroundProfilePic.addSubviews(photoIcon)
        
        photoIcon.translatesAutoresizingMaskIntoConstraints = false
        backgroundProfilePic.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundProfilePic.topAnchor.constraint(equalTo: margin.topAnchor),
            backgroundProfilePic.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            backgroundProfilePic.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            backgroundProfilePic.widthAnchor.constraint(equalToConstant: 96),
            backgroundProfilePic.heightAnchor.constraint(equalToConstant: 96),
    
          
            photoIcon.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            photoIcon.centerYAnchor.constraint(equalTo: margin.centerYAnchor),
            photoIcon.widthAnchor.constraint(equalToConstant: 24),
            photoIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        for photoFromLibrary in photosFromLibrary {
            photoFromLibrary.translatesAutoresizingMaskIntoConstraints = false
            print("lewat juga")
            backgroundProfilePic.addSubviews(photoFromLibrary)
            backgroundProfilePic.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                photoFromLibrary.topAnchor.constraint(equalTo: backgroundProfilePic.topAnchor),
                photoFromLibrary.bottomAnchor.constraint(equalTo: backgroundProfilePic.bottomAnchor),
                photoFromLibrary.leadingAnchor.constraint(equalTo: backgroundProfilePic.leadingAnchor),
                photoFromLibrary.trailingAnchor.constraint(equalTo: backgroundProfilePic.trailingAnchor)
            ])
        }
    }
}

final class NameTextFieldViewCell: UITableViewCell {
    
    private lazy var namaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.text = "Nama*"
         return label
    }()
    
    private lazy var namaTextField: SHRoundedTextfield = {
        let textField = SHRoundedTextfield()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setPlaceholder(placeholder: "Nama")
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubviews(
            namaLabel,
            namaTextField
        )
        
        NSLayoutConstraint.activate([
            namaLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            namaLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            
            namaTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            namaTextField.topAnchor.constraint(equalTo: namaLabel.bottomAnchor, constant: 4),
            namaTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            namaTextField.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
}

final class KotaTextFieldViewCell: UITableViewCell {
    
    private lazy var kotaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.text = "Kota*"
         return label
    }()

    private lazy var dropDown: SHDropDownTextField = {
        let  dropDown = SHDropDownTextField()

        let getData = DataForCityInIndonesia()
        dropDown.optionArray = getData.dataKotaBersih
//        dropDown.optionIds = [1,23,54,22]
        dropDown.setPlaceholder(placeholder: "Pilih Kota")
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        return dropDown
    }()
//    private lazy var triangleIndicator: UIImageView = {
//        let image = UIImage(named: "img-chevron-down")
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addDropDown()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addDropDown() {
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubviews(
            kotaLabel,
//            kotaTextField
            dropDown
        )
        
//        kotaTextField.rightView = triangleIndicator
//        kotaTextField.rightViewMode = .unlessEditing
//
        NSLayoutConstraint.activate([
            kotaLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            kotaLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            
            dropDown.topAnchor.constraint(equalTo: kotaLabel.bottomAnchor),
            dropDown.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            dropDown.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            dropDown.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            dropDown.heightAnchor.constraint(equalToConstant: 48)
//
//            kotaTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
//            kotaTextField.topAnchor.constraint(equalTo: kotaLabel.bottomAnchor, constant: 4),
//            kotaTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
//            kotaTextField.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
            
        ])
    }
}

class AlamatTextField: UITableViewCell {
    lazy var namaCustom: String = "Alamat*"
    lazy var placeHolderCustom: String = "Contoh: Jalan Ikan Hiu 33"
    
    lazy var customLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.text = namaCustom
         return label
    }()
    
    lazy var customTextField: SHLongRoundedTextfield = {
        let textField = SHLongRoundedTextfield()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setPlaceholder(placeholder: placeHolderCustom)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConfiguration() {
        let margin = contentView.layoutMarginsGuide
        contentView.addSubviews(
            customLabel,
            customTextField
        )
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            
            customTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customTextField.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 4),
            customTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            customTextField.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
        ])
    }
    
}

class NomorTextField: UITableViewCell {
    lazy var namaCustom: String = "No Handphone*"
    lazy var placeHolderCustom: String = "Contoh: +628123456789"
    
    lazy var customLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.text = namaCustom
         return label
    }()
    
    lazy var customTextField: SHRoundedTextfield = {
        let textField = SHRoundedTextfield()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setPlaceholder(placeholder: placeHolderCustom)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConfiguration() {
        let margin = contentView.layoutMarginsGuide
        contentView.addSubviews(
            customLabel,
            customTextField
        )
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            
            customTextField.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customTextField.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 4),
            customTextField.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            customTextField.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
        ])
    }
    
}

final class SimpanButton: UITableViewCell {
    private lazy var signInButton: SHButton = {
        let button = SHButton(frame: CGRect(), title: "Simpan", type: .filled, size: .regular)
        button.addTarget(self, action: #selector(handleSimpanButton), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConfiguration() {
        let margin = contentView.layoutMarginsGuide
        contentView.addSubviews(signInButton)
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            signInButton.topAnchor.constraint(equalTo: margin.topAnchor),
            signInButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            signInButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc func handleSimpanButton() {
        
    }
}
