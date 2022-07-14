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
        let isActive = UserDefaults.standard.bool(forKey: "isHomeProductSorterShown")
        toggle.setOn(isActive, animated: true)
        toggle.onTintColor = UIColor(rgb: 0x7126B5)
        return toggle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeProductSorterToggle.addTarget(self, action: #selector(onHomeSorterToggleChange), for: .valueChanged)
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        let text = NSAttributedString(
            string: "Tampilkan tombol pembantu urutan produk di halaman home",
            attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!]
        )
        cell.accessoryView = homeProductSorterToggle
        config.attributedText = text
        cell.contentConfiguration = config
        return cell
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
    
}
