//
//  HomeSearchViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

//final class HomeSearchViewController: UITableViewController {
//
//    var searchBar = SHRoundedTextfield()
//    var closeButton = UIImageView()
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchBarCell")
//        tableView.register(HomeSearchCell.self, forCellReuseIdentifier: "\(HomeSearchCell.self)")
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let row = indexPath.row
//        switch row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "searchBarCell", for: indexPath)
//            cell.contentView.addSubviews(searchBar, closeButton)
//            closeButton.translatesAutoresizingMaskIntoConstraints = false
//            closeButton.tintColor = .secondaryLabel
//            closeButton.image = UIImage(systemName: "xmark")
//            closeButton.isUserInteractionEnabled = true
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
//            closeButton.addGestureRecognizer(tapRecognizer)
//            searchBar.translatesAutoresizingMaskIntoConstraints = false
//            closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
//            closeButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
//            searchBar.placeholder = "Cari di SecondHand"
//            searchBar.rightView = nil
//            searchBar.rightView = closeButton
//            searchBar.backgroundColor = .secondarySystemBackground
//            searchBar.rightViewMode = .unlessEditing
//
//            NSLayoutConstraint.activate([
//                searchBar.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
//                searchBar.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
//                searchBar.widthAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.widthAnchor),
//                searchBar.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor),
//                searchBar.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor),
//
//                cell.contentView.heightAnchor.constraint(greaterThanOrEqualTo: searchBar.heightAnchor)
//            ])
//            return cell
//
//        default:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(HomeSearchCell.self)", for: indexPath) as? HomeSearchCell else {
//                return UITableViewCell()
//            }
//            return cell
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    @objc private func dismissView() {
//        self.dismiss(animated: false)
//    }
//
//}
//
//final class HomeSearchCell: UITableViewCell {
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        defineLayout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func defineLayout() {
//
//    }
//}



final class HomeSearchCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        
    }
}
