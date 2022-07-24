//
//  AccountTableViewController.swift
//  SecondHand
//
//  Created by Muhammad dhani Bukhory on 21/06/22.
//
import Foundation
import UIKit
import Kingfisher
import CoreData

class AccountTableViewController: UITableViewController {
    
    var signedInUsers: [NSManagedObject] = []
    private lazy var popUpView: SHPopupView = SHPopupView(frame: CGRect.zero, popupType: .success, text: "Berhasil merubah akun")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        loadUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileViewCell.self, forCellReuseIdentifier: "\(ProfileViewCell.self)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "notSignedInCell")
        tableView.separatorStyle = .none
        title = "Akun Saya"
        navigationController?.navigationBar.useSHLargeTitle()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.contentView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        var config = cell.defaultContentConfiguration()
        switch row {
        case 0:
            guard !signedInUsers.isEmpty else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "notSignedInCell", for: indexPath)
                var config = cell.defaultContentConfiguration()
                config.image = UIImage(systemName: "person.badge.plus")?.withTintColor(UIColor(rgb: 0x7126B5))
                config.attributedText = NSAttributedString(string: "Masuk", attributes: [.font : UIFont(name: "Poppins-Medium", size: 14)!])
                config.imageProperties.tintColor = UIColor(rgb: 0x7126B5)
                cell.contentConfiguration = config
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(ProfileViewCell.self)",
                for: indexPath
            ) as? ProfileViewCell
            else {
                return UITableViewCell()
            }
            if !signedInUsers.isEmpty {
                let user = signedInUsers[0]
                print(user)
                guard let imageUrl = user.value(forKey: "image_url") as? String else { return cell }
                print(imageUrl)
                guard !imageUrl.isEmpty else { return cell }
                cell.iconphoto.image = nil
                cell.profileImageView.kf.indicatorType = .activity
                cell.profileImageView.kf.setImage(with: URL(string: imageUrl), options: [.cacheOriginalImage, .transition(.fade(0.25))])
            }
            return cell
            
        case 1:
            config.image = UIImage(named: "img-sh-edit")
            config.attributedText = NSAttributedString(string: "Ubah Akun", attributes: [.font : UIFont(name: "Poppins-Medium", size: 14)!])
            cell.contentConfiguration = config
            if !isSignedIn {
                cell.isHidden = true
            }
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
            if !isSignedIn {
                cell.isHidden = true
            }
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        switch row {
        case 0:
            if signedInUsers.isEmpty {
                let vc = SignInViewController()
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                self.tabBarController?.navigationController?.present(navigationController, animated: true)
//                self.navigationController?.present(navigationController, animated: true)
            } else {
                let viewController = AccountDetailViewController()
                navigationController?.pushViewController(viewController, animated: true)
            }
        case 1:
            let viewController = CompleteAccountViewController()
            viewController.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController = SettingsViewController(style: .insetGrouped)
            navigationController?.pushViewController(viewController, animated: true)
        case 3:
            let alertController = UIAlertController(title: "Keluar", message: "Apakah anda yakin ingin keluar?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Batal", style: .cancel)
            let signOut = UIAlertAction(title: "Keluar", style: .destructive) { [weak self] _ in
                guard let _self = self else { return }
                DispatchQueue.main.async {
                    _self.removeSignedInUserData()
                    _self.tableView.reloadData()
                }
            }
            alertController.addAction(cancel)
            alertController.addAction(signOut)
            self.present(alertController, animated: true)
        default:
            return
        }
    }
    
    private func loadUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SignedInUser")
        do {
            signedInUsers = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func removeSignedInUserData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            for user in signedInUsers {
                managedContext.delete(user)
            }
            try managedContext.save()
            UserDefaults.standard.set(false, forKey: "isHomeProductSorterShown")
            UserDefaults.standard.set(nil, forKey: "accessToken")
            UserDefaults.standard.set(false, forKey: "isSignedIn")
            KingfisherManager.shared.cache.clearCache()
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileViewCell else { return }
            cell.profileImageView.image = nil
            cell.iconphoto.image = UIImage(named: "img-sh-camera")
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
extension AccountTableViewController: DidClickSaveButtonAction {
    func didClickButton(info: Bool) {
        if info {
            view.addSubview(popUpView)
            popUpView.translatesAutoresizingMaskIntoConstraints = false
            popUpView.isPresenting.toggle()
            
            NSLayoutConstraint.activate([
                popUpView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 50),
                popUpView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 16),
                popUpView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -16)
            ])
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
    
    var iconphoto: UIImageView = {
        let photo = UIImage(named: "img-sh-camera")
        let photoView = UIImageView(image: photo)
        return photoView
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        return imageView
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
        contentView.addSubviews(backgroundProfile, profileImageView)
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
            profileImageView.centerXAnchor.constraint(equalTo: backgroundProfile.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: backgroundProfile.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 96),
            profileImageView.heightAnchor.constraint(equalToConstant: 96)
        ])
    }
}
