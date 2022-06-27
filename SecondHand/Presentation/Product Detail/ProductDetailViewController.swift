//
//  ProductDetailViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 16/06/22.
//

import PhotosUI
import UIKit

final class ProductDetailViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Lengkapi Detail Produk"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 14)!]
        
        tableView.register(NamaProdukTextField.self, forCellReuseIdentifier: "\(NamaProdukTextField.self)")
        tableView.register(HargaProdukTextField.self, forCellReuseIdentifier: "\(HargaProdukTextField.self)")
        tableView.register(KategoriTextField.self, forCellReuseIdentifier: "\(KategoriTextField.self)")
        tableView.register(DeskripsiTextField.self, forCellReuseIdentifier: "\(DeskripsiTextField.self)")
        tableView.register(FotoProdukViewCell.self, forCellReuseIdentifier: "\(FotoProdukViewCell.self)")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "\(ButtonCell.self)")
        
        tableView.separatorStyle = .none
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NamaProdukTextField.self)", for: indexPath) as? NamaProdukTextField else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "\(HargaProdukTextField.self)", for: indexPath) as? HargaProdukTextField else {
                return UITableViewCell()
            }
            cell2.selectionStyle = .none
            return cell2

        case 2:
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "\(KategoriTextField.self)", for: indexPath) as? KategoriTextField else {
                return UITableViewCell()
            }
            cell3.selectionStyle = .none
            return cell3
        case 3:
            guard let cell4 = tableView.dequeueReusableCell(withIdentifier: "\(DeskripsiTextField.self)", for: indexPath) as? DeskripsiTextField else {
                return UITableViewCell()
            }
            cell4.selectionStyle = .none
            return cell4

        case 4:
            guard let cell5 = tableView.dequeueReusableCell(withIdentifier: "\(FotoProdukViewCell.self)", for: indexPath) as? FotoProdukViewCell else {
                return UITableViewCell()
            }
            cell5.viewController = self
            cell5.selectionStyle = .none
            return cell5
//
        case 5:
            guard let cell6 = tableView.dequeueReusableCell(withIdentifier: "\(ButtonCell.self)", for: indexPath) as? ButtonCell else {
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

final class NamaProdukTextField: SHCustomTextFieldForm {
    
    override func addConfiguration() {
        self.setTextFieldName(nama: "Nama Produk", placeHolderLabel: "Nama Produk")
        addConstraintForTextField()
    }
}

final class HargaProdukTextField: SHCustomTextFieldForm {
    override func addConfiguration() {
        self.setTextFieldName(nama: "Harga Produk", placeHolderLabel: "Rp 0,00")
        addConstraintForTextField()
    }
}

final class KategoriTextField: SHCustomTextFieldForm {

    private lazy var dropDown: SHDropDownTextField = {
        let  dropDown = SHDropDownTextField()

        dropDown.optionArray = ["Option 1", "Option 2", "Option 3"]
        dropDown.setPlaceholder(placeholder: "Pilih Kategori")
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        return dropDown
    }()
    
    override func addConfiguration() {
        self.setTextFieldName(nama: "Kategori", placeHolderLabel: "Pilih Kategori")
        
        addConstraintForTextField()
    }
    
    override func addConstraintForTextField() {
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubviews(
            self.customLabel,
            dropDown
        )
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            
            dropDown.topAnchor.constraint(equalTo: customLabel.bottomAnchor),
            dropDown.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            dropDown.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            dropDown.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            dropDown.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    
}

final class DeskripsiTextField: SHCustomTextFieldForm {
    
    lazy var deskripsiTextFieldView: SHLongRoundedTextfield = {
        let textField = SHLongRoundedTextfield()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Contoh: Jalan Ikan Hiu 33"
        return textField
    }()
    
    override func addConfiguration() {
        self.setTextFieldName(nama: "Deskripsi", placeHolderLabel: "Contoh: Jalan Ikan Hiu 33")
        addConstraintForTextField()
    }
    
    override func addConstraintForTextField() {
        
        let margin = contentView.layoutMarginsGuide
        contentView.addSubviews(
            self.customLabel,
            deskripsiTextFieldView
        )
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            
            deskripsiTextFieldView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            deskripsiTextFieldView.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 4),
            deskripsiTextFieldView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            deskripsiTextFieldView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
        ])
    }
}

final class FotoProdukViewCell : SHCustomTextFieldForm, PHPickerViewControllerDelegate {

    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    var photosFromLibrary:[UIImageView] = []
    
    private lazy var photoIcon: UIImageView = {
        let lm = contentView.layoutMargins
        let photo = UIImage(named: "img-sh-plus")
        let photoView = UIImageView(image: photo)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .center

        return photoView
    }()
    
    private lazy var photoPlace: UIView = {
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
        
        let shapeView = UIView() //frame: CGRect(x: 0, y: 0, width: 96, height: 96)
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
        viewController?.present(pickerVC, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results[0].itemProvider.loadObject(ofClass: UIImage.self) {[weak self] reading, error in
            if let image = reading as? UIImage {
                DispatchQueue.main.async {
                    let imv = self?.newImageView(image: image)
                    self?.photosFromLibrary.append(imv!)
                    self?.photoPlace.bringSubviewToFront(imv!)
                    self?.viewController?.view.setNeedsLayout()
                    self?.addConfiguration()
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
    
    override func addConfiguration() {
        self.setTextFieldName(nama: "Foto Produk", placeHolderLabel: "")
        addConstraintForTextField()
    }
    
    override func addConstraintForTextField() {
        let margin = contentView.layoutMarginsGuide
        photoPlace.addSubviews(photoIcon)
        contentView.addSubviews(
            self.customLabel,
            photoPlace
        )
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            customLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            
            photoPlace.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            photoPlace.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 4),
            photoPlace.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            photoPlace.widthAnchor.constraint(equalToConstant: 96),
            photoPlace.heightAnchor.constraint(equalToConstant: 96),
            
            photoIcon.trailingAnchor.constraint(equalTo: photoPlace.trailingAnchor),
            photoIcon.leadingAnchor.constraint(equalTo: photoPlace.leadingAnchor),
            photoIcon.topAnchor.constraint(equalTo: photoPlace.topAnchor),
            photoIcon.bottomAnchor.constraint(equalTo: photoPlace.bottomAnchor)
            
        ])
        for photoFromLibrary in photosFromLibrary {
            photoFromLibrary.translatesAutoresizingMaskIntoConstraints = false
            print("lewat juga")
            photoPlace.addSubviews(photoFromLibrary)
            
            NSLayoutConstraint.activate([
                photoFromLibrary.topAnchor.constraint(equalTo: photoPlace.topAnchor),
                photoFromLibrary.bottomAnchor.constraint(equalTo: photoPlace.bottomAnchor),
                photoFromLibrary.leadingAnchor.constraint(equalTo: photoPlace.leadingAnchor),
                photoFromLibrary.trailingAnchor.constraint(equalTo: photoPlace.trailingAnchor)
            ])
        }
    }
}

final class ButtonCell: SHCustomTextFieldForm {
    
    private lazy var previewButton: SHButton = {
        let button = SHButton(frame: CGRect(), title: "Preview", type: .bordered, size: .small)
        button.addTarget(self, action: #selector(handleSimpanButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var terbitkanButton: SHButton = {
        let button = SHButton(frame: CGRect(), title: "Terbitkan", type: .filled, size: .regular)
        button.addTarget(self, action: #selector(handleSimpanButton), for: .touchUpInside)
        return button
    }()
    
    override func addConstraintForTextField() {
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubviews(
            previewButton,
            terbitkanButton
        )
        
        NSLayoutConstraint.activate([
            previewButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            previewButton.topAnchor.constraint(equalTo: margin.topAnchor),
            previewButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            previewButton.heightAnchor.constraint(equalToConstant: 48),
            previewButton.widthAnchor.constraint(equalTo: terbitkanButton.widthAnchor),
            
            terbitkanButton.leadingAnchor.constraint(equalTo: previewButton.trailingAnchor, constant: 16),
            terbitkanButton.topAnchor.constraint(equalTo: margin.topAnchor),
            terbitkanButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            terbitkanButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
    @objc func handleSimpanButton() {
        
    }
}
