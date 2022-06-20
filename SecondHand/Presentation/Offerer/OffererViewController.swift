//
//  OffererViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 20/06/22.
//

import UIKit

final class OffererViewController: UITableViewController {
    
    enum OffererViewCellSectionType: Int {
        case offerer = 0
        case product = 1
    }
    
    private typealias sectionType = OffererViewCellSectionType
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(OffererDetailCell.self, forCellReuseIdentifier: "\(OffererDetailCell.self)")
        tableView.register(OffererProductCell.self, forCellReuseIdentifier: "\(OffererProductCell.self)")
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Daftar produkmu yang ditawar"

        default:
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case sectionType.offerer.rawValue:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(OffererDetailCell.self)", for: indexPath
            ) as? OffererDetailCell else {
                return UITableViewCell()
            }
            cell.fill()
            cell.selectionStyle = .none
            return cell
            
        case sectionType.product.rawValue:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(OffererProductCell.self)", for: indexPath
            ) as? OffererProductCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.onRejectButtonTap = {
                
            }
            cell.onAcceptButtonTap = {
                
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    private func setupNavigationBar() {
        title = "Info Penawar"
    }
}
