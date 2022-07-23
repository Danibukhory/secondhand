//
//  UserDetailViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 19/07/22.
//

import UIKit
import CoreData

final class AccountDetailViewController: UITableViewController {
    
    var user: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Detail"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userDetailCell")
        loadUser()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var _user: NSManagedObject?
        if !user.isEmpty {
            _user = user[0]
        }
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailCell", for: indexPath)
        cell.selectionStyle = .none
        var config = cell.defaultContentConfiguration()
        config.prefersSideBySideTextAndSecondaryText = true
        switch row {
        case 0:
            config.attributedText = NSAttributedString(
                string: "User ID",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: "\(_user?.value(forKey: "id") as? Int ?? 0)",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 1:
            config.attributedText = NSAttributedString(
                string: "Nama lengkap",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: _user?.value(forKey: "full_name") as? String ?? "",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 2:
            config.attributedText = NSAttributedString(
                string: "Email",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: _user?.value(forKey: "email") as? String ?? "",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 3:
            config.attributedText = NSAttributedString(
                string: "Password",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: _user?.value(forKey: "password") as? String ?? "",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 4:
            config.attributedText = NSAttributedString(
                string: "Nomor Telepon",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: _user?.value(forKey: "phone_number") as? String ?? "",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 5:
            config.attributedText = NSAttributedString(
                string: "Alamat",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: _user?.value(forKey: "address") as? String ?? "",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 6:
            config.attributedText = NSAttributedString(
                string: "Kota",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: _user?.value(forKey: "city") as? String ?? "",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 7:
            config.attributedText = NSAttributedString(
                string: "Image URL",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: _user?.value(forKey: "image_url") as? String ?? "",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 8:
            config.attributedText = NSAttributedString(
                string: "Dibuat pada",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: (_user?.value(forKey: "createdAt") as? String ?? "").convertToDateString(dateFormat: "dd MM yyyy"),
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
            
        case 9:
            config.attributedText = NSAttributedString(
                string: "Diedit pada",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            config.secondaryAttributedText = NSAttributedString(
                string: (_user?.value(forKey: "updatedAt") as? String ?? "").convertToDateString(dateFormat: "dd MM yyyy"),
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!, .foregroundColor : UIColor.secondaryLabel]
                )
            cell.contentConfiguration = config
            return cell
        default:
            return cell
        }
    }
    
    private func loadUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SignedInUser")
        do {
            user = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
