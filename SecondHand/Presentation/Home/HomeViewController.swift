//
//  HomeViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

final class HomeViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
        tableView.register(HomeHeaderCell.self, forCellReuseIdentifier: "\(HomeHeaderCell.self)")
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "\(HomeProductCell.self)")
        tableView.backgroundColor = UIColor(rgb: 0xFFE9C9)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(HomeHeaderCell.self)", for: indexPath) as? HomeHeaderCell else {
                return UITableViewCell()
            }
            return cell
            
        case 1:
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "\(HomeProductCell.self)", for: indexPath) as? HomeProductCell else {
                return UITableViewCell()
            }
            return cell2
        default:
            return UITableViewCell()
        }
        
    }
    
    private func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapRecognizer)
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc private func hideKeyboard() {
        tableView.endEditing(true)
    }
    
}

