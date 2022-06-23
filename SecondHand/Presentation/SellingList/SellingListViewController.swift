//
//  SellingListViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import UIKit

final class SellingListViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Daftar Jual Saya"
        label.font = UIFont(name:"Poppins-Bold",size:32)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(NamePenjualTextFieldViewCell.self, forCellReuseIdentifier: "\(NamePenjualTextFieldViewCell.self)")
        titlelabel()
        view.backgroundColor = .systemBackground
      
func titlelabel () {
view.addSubviews(titleLabel)
NSLayoutConstraint.activate([
    titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15),
    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
    ])

   }
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = indexPath.row
    switch row {
    case 0:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NamePenjualTextFieldViewCell.self)", for: indexPath) as? NamePenjualTextFieldViewCell else {
            return UITableViewCell()
        }
        return cell
        
    default:
    return UITableViewCell()
   }

}
final class NamePenjualTextFieldViewCell: UITableViewCell {
    
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


