//
//  SellingListViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import UIKit

final class SellingListViewController: UIViewController {
    
    enum SectionSellingList: Int {
        case Top = 0
        case Main = 1
        case Bottom = 2
    }
    
    var category: Int = 0
    
    var testModel = TestModel()

    private lazy var sellingListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sllist-cell")
        tableView.register(TopSellingListTableViewCell.self, forCellReuseIdentifier: TopSellingListTableViewCell.identifier)
        tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        tableView.register(AddProductTableViewCell.self, forCellReuseIdentifier: AddProductTableViewCell.identifier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func configure() {
        view.addSubview(sellingListTableView)
        sellingListTableView.delegate = self
        sellingListTableView.dataSource = self
        NSLayoutConstraint.activate([
            sellingListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sellingListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sellingListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sellingListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

}

extension SellingListViewController: UITableViewDelegate,UITableViewDataSource,CategoriesDelegate {
    
    func setCategories(_ category: Int) {
        self.category = category
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case SectionSellingList.Top.rawValue:
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: TopSellingListTableViewCell.identifier, for: indexPath) as? TopSellingListTableViewCell else {
                return UITableViewCell()
            }
            tableViewCell.selectionStyle = .none
            return tableViewCell
        case SectionSellingList.Main.rawValue:
            guard let rowViewCell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.identifier, for: indexPath) as? CategoriesTableViewCell else {
                return UITableViewCell()
            }
            
            rowViewCell.selectionStyle = .none

            return rowViewCell
            
            
        case SectionSellingList.Bottom.rawValue:

            if testModel.category == 0 {
                guard let btViewCell = tableView.dequeueReusableCell(withIdentifier: AddProductTableViewCell.identifier, for: indexPath) as? AddProductTableViewCell else {
                    return UITableViewCell()
                }

                btViewCell.selectionStyle = .none
                return btViewCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sllist-cell", for: indexPath) as UITableViewCell

                return cell
            }
            
           
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80
        } else if indexPath.row == 1{
            return 80
        } else {
            return 900
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80
        } else if indexPath.row == 1{
            return 80
        } else {
            return 900
        }
    }
}



