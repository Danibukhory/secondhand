//
//  AccountTableViewController.swift
//  SecondHand
//
//  Created by Muhammad dhani Bukhory on 21/06/22.
//
import Foundation
import UIKit

class AccountTableViewController: UITableViewController {
       

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Akun Saya"
        label.font = UIFont(name:"Poppins-Bold",size:32)
        return label
    }()
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.register(ProfileViewCell.self, forCellReuseIdentifier: "\(ProfileViewCell.self)")
            tableView.register(ChangeAccountViewCell.self, forCellReuseIdentifier: "\(ChangeAccountViewCell.self)")
            tableView.register(SettingAccountViewCell.self, forCellReuseIdentifier: "\(SettingAccountViewCell.self)")
            tableView.register(LogOutAccountViewCell.self, forCellReuseIdentifier: "\(LogOutAccountViewCell.self)")
            titlelabel()
            tableView.separatorStyle = .none
        }
    func titlelabel () {
        view.addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            ])
        
    }
    
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let row = indexPath.row
            switch row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProfileViewCell.self)", for: indexPath) as? ProfileViewCell else {
                    return UITableViewCell()
                }
                return cell
            case 1:
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "\(ChangeAccountViewCell.self)", for: indexPath) as? ChangeAccountViewCell else {
                    return UITableViewCell()
                }
                return cell1
            case 2:
                guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "\(SettingAccountViewCell.self)", for: indexPath) as? SettingAccountViewCell else {
                    return UITableViewCell()
                }
                return cell2
            case 3:
                guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "\(LogOutAccountViewCell.self)", for: indexPath) as? LogOutAccountViewCell else {
                    return UITableViewCell()
                }
                return cell3

                    
            default:
                return UITableViewCell()
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
                iconphoto.widthAnchor.constraint(equalToConstant: 22),
                iconphoto.heightAnchor.constraint(equalToConstant: 18),

            ])
        }
    }
final class ChangeAccountViewCell: UITableViewCell {
    
    private lazy var changeaccount: UIImageView = {
        let photo = UIImage(named: "img-sh-edit")
        let photoView = UIImageView(image: photo)
        return photoView
    }()
    private lazy var changelabelaccount: UILabel = {
        let label = UILabel()
        label.text = "Ubah Akun"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
       ChangeIcon()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    private func ChangeIcon() {
        let margin = contentView.layoutMarginsGuide
        contentView.addSubviews(changeaccount,changelabelaccount)
        changeaccount.translatesAutoresizingMaskIntoConstraints = false
        changelabelaccount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changeaccount.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            changelabelaccount.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -220)
        ])
    }
}
final class SettingAccountViewCell: UITableViewCell {
    
    private lazy var settingaccount: UIImageView = {
        let photo = UIImage(named: "img-sh-edit")
        let photoView = UIImageView(image: photo)
        return photoView
    }()
    private lazy var settinglabelaccount: UILabel = {
        let label = UILabel()
        label.text = "Pengaturan"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
       SettingIcon()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    private func SettingIcon() {
        let margin = contentView.layoutMarginsGuide
        contentView.addSubviews(settingaccount,settinglabelaccount)
        settingaccount.translatesAutoresizingMaskIntoConstraints = false
        settinglabelaccount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingaccount.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            settinglabelaccount.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -220)
        ])
    }
}
final class LogOutAccountViewCell: UITableViewCell {
    
    private lazy var logoutaccount: UIImageView = {
        let photo = UIImage(named: "img-sh-logout")
        let photoView = UIImageView(image: photo)
        return photoView
    }()
    private lazy var logoutlabelaccount: UILabel = {
        let label = UILabel()
        label.text = "Keluar"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
       LogOutIcon()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    private func LogOutIcon() {
        let margin = contentView.layoutMarginsGuide
        contentView.addSubviews(logoutaccount,logoutlabelaccount)
        logoutaccount.translatesAutoresizingMaskIntoConstraints = false
        logoutlabelaccount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutaccount.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            logoutlabelaccount.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -260)
        ])
    }
}
        
        
        
        
        
        

        
        
        
        
        

        
        
        
        
        
