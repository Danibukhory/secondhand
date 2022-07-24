//
//  SettingsViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 12/07/22.
//

import UIKit

final class SettingsViewController: UITableViewController {
    
    var homeProductSorterToggle: UISwitch = {
        let toggle = UISwitch()
        let isSorterButtonShown: Bool = UserDefaults.standard.bool(forKey: "isHomeProductSorterShown")
        toggle.setOn(isSorterButtonShown, animated: true)
        toggle.onTintColor = UIColor(rgb: 0x7126B5)
        return toggle
    }()
    
    var signedInToggle: UISwitch = {
        let toggle = UISwitch()
        let isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        toggle.setOn(isSignedIn, animated: true)
        toggle.onTintColor = UIColor(rgb: 0x7126B5)
        return toggle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeProductSorterToggle.addTarget(self, action: #selector(onHomeSorterToggleChange), for: .valueChanged)
        signedInToggle.addTarget(self, action: #selector(onSignedInToggleChange), for: .valueChanged)
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Experimental"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        switch section {
        case 0:
            let text = NSAttributedString(
                string: "Tampilkan tombol pembantu urutan produk di halaman home",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            cell.accessoryView = homeProductSorterToggle
            config.attributedText = text
            cell.contentConfiguration = config
            return cell
        case 1:
            let text = NSAttributedString(
                string: "Signed in",
                attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
            )
            cell.accessoryView = signedInToggle
            config.attributedText = text
            cell.contentConfiguration = config
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    private func setupNavigationBar() {
        title = "Pengaturan"
        navigationController?.navigationBar.useSHLargeTitle()
    }
    
    @objc func onHomeSorterToggleChange() {
        if homeProductSorterToggle.isOn {
            UserDefaults.standard.set(true, forKey: "isHomeProductSorterShown")
        } else {
            UserDefaults.standard.set(false, forKey: "isHomeProductSorterShown")
        }
    }
    
    @objc func onSignedInToggleChange() {
        if signedInToggle.isOn {
            UserDefaults.standard.set(true, forKey: "isSignedIn")
        } else {
            UserDefaults.standard.set(false, forKey: "isSignedIn")
        }
    }
    
}
