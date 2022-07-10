//
//  AccountTableViewController.swift
//  SecondHand
//
//  Created by Muhammad dhani Bukhory on 21/06/22.
//
import Foundation
import UIKit

class AccountTableViewController: UITableViewController {
       

//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Akun Saya"
//        label.font = UIFont(name:"Poppins-Bold",size:32)
//        return label
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileViewCell.self, forCellReuseIdentifier: "\(ProfileViewCell.self)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
        tableView.separatorStyle = .none
        title = "Akun Saya"
        navigationController?.navigationBar.useSHLargeTitle()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.contentView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        var config = cell.defaultContentConfiguration()
        switch row {
        case 0:
            guard let _cell = tableView.dequeueReusableCell(
                withIdentifier: "\(ProfileViewCell.self)",
                for: indexPath
            ) as? ProfileViewCell
            else {
                return UITableViewCell()
            }
            return _cell
            
        case 1:
            config.image = UIImage(named: "img-sh-edit")
            config.attributedText = NSAttributedString(string: "Ubah Akun", attributes: [.font : UIFont(name: "Poppins-Medium", size: 14)!])
            cell.contentConfiguration = config
            return cell
            
        case 2:
            config.image = UIImage(named: "img-sh-settings")
            config.attributedText = NSAttributedString(string: "Pengaturan Akun", attributes: [.font : UIFont(name: "Poppins-Medium", size: 14)!])
            cell.contentConfiguration = config
            return cell
            
        default:
            config.image = UIImage(named: "img-sh-logout")
            config.attributedText = NSAttributedString(string: "Keluar", attributes: [.font : UIFont(name: "Poppins-Medium", size: 14)!])
            cell.contentConfiguration = config
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        
        if row == 3 {
            UserDefaults.standard.set(false, forKey: "isLogin")
            let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
            if !isLogin {
                let viewController = UINavigationController(rootViewController: SignInViewController())
                viewController.modalPresentationStyle = .fullScreen
                navigationController?.present(viewController, animated: true)
                tabBarController?.selectedIndex = 0
            }
        }
    }
}

final class ProfileViewCell: UITableViewCell {
    
    private lazy var backgroundProfile: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor(rgb: 0xE2D4F0)
        backView.layer.cornerRadius = 12
        return backView
    }()
    
    private lazy var iconphoto: UIImageView = {
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
        contentView.addSubviews(backgroundProfile)
        backgroundProfile.addSubviews(iconphoto)
        iconphoto.translatesAutoresizingMaskIntoConstraints = false
        backgroundProfile.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundProfile.topAnchor.constraint(equalTo: margin.topAnchor, constant: 60),
            backgroundProfile.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -60),
            backgroundProfile.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            backgroundProfile.widthAnchor.constraint(equalToConstant: 96),
            backgroundProfile.heightAnchor.constraint(equalToConstant: 96),
            iconphoto.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            iconphoto.centerYAnchor.constraint(equalTo: margin.centerYAnchor),
            iconphoto.widthAnchor.constraint(equalToConstant: 24),
            iconphoto.heightAnchor.constraint(equalToConstant: 24),
            
        ])
    }
}
