//
//  HomeViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit

enum HomeViewCellRowType: Int {
    case header = 0
    case product = 1
}

final class HomeViewController: UITableViewController {
    
    var searchTableView = UITableView()
    var products: [SHSellerProductResponse] = []
    
    private typealias rowType = HomeViewCellRowType
    
    private var signInData: SignInResponse = SignInResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
        setupSearchTableView()
        loadProducts()
        tableView.register(HomeHeaderCell.self, forCellReuseIdentifier: "\(HomeHeaderCell.self)")
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "\(HomeProductCell.self)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "loadingCell")
        tableView.backgroundColor = UIColor(rgb: 0xFFE9C9)
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        handleAuth()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case searchTableView:
            return 40
        default:
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch tableView {
        case searchTableView:
            return UITableViewCell()
        default:
            switch row {
            case rowType.header.rawValue:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "\(HomeHeaderCell.self)",
                    for: indexPath
                ) as? HomeHeaderCell else {
                    return UITableViewCell()
                }
                cell.onSearchBarTap = { [weak self] in
                    guard let _self = self else { return }
                    _self.view.bringSubviewToFront(_self.searchTableView)
                    _self.searchTableView.fadeIn()
                    _self.searchTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    _self.tableView.isScrollEnabled = false
                }
                cell.onDismissButtonTap = { [weak self] in
                    guard let _self = self else { return }
                    cell.searchBar.rightView = cell.searchImageView
                    _self.searchTableView.fadeOut()
                    _self.tableView.isScrollEnabled = true
                }
                return cell
                
            case rowType.product.rawValue:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "\(HomeProductCell.self)",
                    for: indexPath
                ) as? HomeProductCell else {
                    let loadingCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
                    loadingCell.contentView.heightAnchor.constraint(equalToConstant: 400).isActive = true
                    return loadingCell
                }
                cell.onProductLoad = { [weak self] in
                    guard let _self = self else { return }
                    _self.tableView.reloadData()
                }
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    private func setupSearchTableView() {
        view.addSubview(searchTableView)
        view.sendSubviewToBack(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.frame = UIScreen.main.bounds
        searchTableView.backgroundColor = UIColor(rgb: 0xFFE9C9)
        searchTableView.alpha = 0
        
        NSLayoutConstraint.activate([
            searchTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 70),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            searchTableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapRecognizer)
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func handleAuth() {
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        if !isLogin {
            let viewController = UINavigationController(rootViewController: SignInViewController())
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.present(viewController, animated: true)
        }
    }
    
    private func loadProducts() {
        let api = SecondHandAPI()
        api.getSellerProducts { [weak self] result, error in
            guard let _self = self else { return }
            _self.products = result ?? []
            _self.tableView.reloadData()
        }
    }
    
    @objc private func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            searchTableView.frame.size.height -= keyboardSize.height
//            searchTableView.beginUpdates()
//            searchTableView.endUpdates()
//        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            searchTableView.frame.size.height += keyboardSize.height
//        }
    }
    
}

