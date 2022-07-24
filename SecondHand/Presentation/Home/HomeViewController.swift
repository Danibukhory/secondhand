//
//  HomeViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 15/06/22.
//

import UIKit
import Alamofire

final class HomeViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    enum HomeViewCellRowType: Int {
        case header = 0
        case product = 1
    }
    
    var api = SecondHandAPI.shared
    var refControl = UIRefreshControl()
    var searchTableView = UITableView()
    var products: [SHBuyerProductResponse] = []
    var displayedProducts: [SHBuyerProductResponse] = []
    var displayedSearchedProducts: [SHBuyerProductResponse] = []
    var recentlyViewedProducts: [SHBuyerProductResponse] = []
    var searchText: String = ""
    var isShowingSorterButton: Bool = false
    
    private typealias rowType = HomeViewCellRowType
    
    private var signInData: SignInResponse = SignInResponse()
    
    var sorterButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.tintColor = UIColor(rgb: 0x7126B5)
        return button
    }()
    
    var isOnTop: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
        setupGestureRecognizers()
        setupSearchTableView()
        setupRefreshControl()
        setupSorterButton()
        registerCells()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        handleSorterButtonShowing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case searchTableView:
            return displayedSearchedProducts.count
        default:
            if displayedProducts.count % 2 == 0 {
                return (displayedProducts.count / 2) + 1
            } else {
                return ((displayedProducts.count + 1) / 2) + 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch tableView {
        case searchTableView:
            guard let searchCell = tableView.dequeueReusableCell(
                withIdentifier: "\(HomeSearchResultCell.self)",
                for: indexPath
            ) as? HomeSearchResultCell else {
                return UITableViewCell()
            }
            searchCell.fill(with: displayedSearchedProducts[row])
            return searchCell
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
                    _self.tableView.isScrollEnabled = false
                }
                cell.onDismissButtonTap = { [weak self] in
                    guard let _self = self else { return }
                    cell.searchBar.rightView = cell.searchImageView
                    _self.searchTableView.fadeOut()
                    _self.tableView.isScrollEnabled = true
                }
                cell.onCategorySelectorLoad = { [weak self] in
                    guard self != nil else { return }
                    DispatchQueue.main.async {
                        let _indexPath = IndexPath(item: 0, section: 0)
                        guard let collectionCell = cell.categoryCollectionView.cellForItem(at: _indexPath)
                                as? CategorySelectorCollectionCell else { return }
                        cell.categoryCollectionView.selectItem(at: _indexPath, animated: true, scrollPosition: .centeredVertically)
                        collectionCell.selectedState()
                        cell.categoryLoadingIndicator.stopAnimating()
                    }
                    cell.categoryCollectionView.alpha = 0
                    cell.categoryCollectionView.fadeIn()
                    self?.tableView.reloadData()
                }
                cell.onCategorySelectorTap = { [weak self] _category in
                    guard let _self = self else { return }
                    if _category.name == "Semua" {
                        _self.displayedProducts = _self.products
                        _self.tableView.reloadData()
                    } else {
                        let filteredProducts: [SHBuyerProductResponse] = _self.products.filter { product in
                            return product.categories.contains(where: {$0.name == _category.name})
                        }
                        _self.displayedProducts = filteredProducts
                        _self.tableView.reloadData()
                    }
                }
                cell.onSearchBarTextChange = { [weak self] searchText in
                    guard let _self = self else { return }
                    if searchText.isEmpty {
                        _self.displayedSearchedProducts = _self.recentlyViewedProducts
                        _self.searchText = searchText
                    } else {
                        let filteredProducts: [SHBuyerProductResponse] = _self.products.filter { product in
                            return product.name.lowercased().contains(searchText.lowercased())
                        }
                        _self.displayedSearchedProducts = filteredProducts
                    }
                    _self.searchTableView.reloadData()
                }
                cell.newTableViewColor = { [weak self] color in
                    guard let _self = self else { return }
                    _self.tableView.backgroundColor = color
                    _self.searchTableView.backgroundColor = color
                }
                return cell
                
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(HomeNewProductCell.self)", for: indexPath) as? HomeNewProductCell else { return UITableViewCell() }
                cell.selectionStyle = .none
                let row = indexPath.row
                let leftProduct = self.displayedProducts[(row * 2) - 2]
                var rightProduct: SHBuyerProductResponse?
                if (row * 2) - 1 <= self.displayedProducts.count - 1  {
                    rightProduct = self.displayedProducts[(row * 2) - 1]
                } else {
                    rightProduct = nil
                }
                cell.fill(with: leftProduct, and: rightProduct)
                cell.onRightProductTap = { [weak self] in
                    guard let _self = self else { return }
                    let viewController = BuyerSixViewController()
                    viewController.buyerResponse = rightProduct
                    _self.tabBarController?.navigationController?.pushViewController(viewController, animated: true)
                }
                cell.onLeftProductTap = { [weak self] in
                    guard let _self = self else { return }
                    let viewController = BuyerSixViewController()
                    viewController.buyerResponse = leftProduct
                    _self.tabBarController?.navigationController?.pushViewController(viewController, animated: true)
                }
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case searchTableView:
            tableView.deselectRow(at: indexPath, animated: true)
            let item = indexPath.item
            let product = displayedSearchedProducts[item]
            let buyerSixVC = BuyerSixViewController()
            var sameProduct: Int = 0
            for prod in self.recentlyViewedProducts {
                if prod.id == product.id {
                    sameProduct += 1
                }
            }
            if sameProduct == 0 {
                self.recentlyViewedProducts.insert(product, at: 0)
            }
            buyerSixVC.buyerResponse = product
            self.tabBarController?.navigationController?.pushViewController(buyerSixVC, animated: true)
        default:
            break
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        sorterButton.fadeOut()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isShowingSorterButton {
            if !decelerate {
                sorterButton.fadeIn()
            } else {
                sorterButton.fadeOut()
            }
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isShowingSorterButton {
            sorterButton.fadeIn()
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
    }
    
    private func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        searchTableView.addGestureRecognizer(tapRecognizer)
        tableView.addGestureRecognizer(tapRecognizer)
        tableView.keyboardDismissMode = .onDrag
        tabBarController?.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupSorterButton() {
        view.addSubview(sorterButton)
        NSLayoutConstraint.activate([
            sorterButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            sorterButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            sorterButton.heightAnchor.constraint(equalToConstant: 40),
            sorterButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        sorterButton.showsMenuAsPrimaryAction = true
        sorterButton.menu = UIMenu(
            title: "Urutkan berdasarkan:",
            image: nil,
            identifier: nil,
            options: .displayInline,
            children: sortMenuElements().reversed()
        )
        handleSorterButtonShowing()
    }
    
    @objc private func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    private func registerCells() {
        tableView.register(HomeHeaderCell.self, forCellReuseIdentifier: "\(HomeHeaderCell.self)")
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "\(HomeProductCell.self)")
        tableView.register(HomeNewProductCell.self, forCellReuseIdentifier: "\(HomeNewProductCell.self)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "loadingCell")
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchHistoryCell")
        searchTableView.register(HomeSearchResultCell.self, forCellReuseIdentifier: "\(HomeSearchResultCell.self)")
    }
    
    private func setupRefreshControl() {
        refControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.refreshControl = refControl
    }
    
    @objc private func refreshPage() {
        api.getBuyerProducts { [weak self] result, error in
            guard let _self = self, let _result = result else {
                let alert = UIAlertController(title: "Error", message: "Terjadi kesalahan ketika mengambil data.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive)
                alert.addAction(action)
                self?.present(alert, animated: true)
                return
            }
            _self.products = _result
            _self.displayedProducts = _self.products
            _self.tableView.reloadData()
            _self.refControl.endRefreshing()
        }
    }
    
    private func loadProducts() {
        api.getBuyerProducts { [weak self] result, error in
            guard let _self = self, let _result = result else {
                let alert = UIAlertController(title: "Error", message: "Terjadi kesalahan ketika mengambil data.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive)
                alert.addAction(action)
                self?.present(alert, animated: true)
                return
            }
            _self.products = _result
            _self.displayedProducts = _self.products
            _self.tableView.reloadData()
        }
    }
    
    private func sortMenuElements() -> [UIMenuElement] {
        var menus: [UIMenuElement] = []
        
        let sortByNameAscending = UIAction(
            title: "Nama (A - Z)",
            image: UIImage(systemName: "a.square"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.displayedProducts.sort(by: { ($0.name) < ($1.name) })
            _self.tableView.reloadData()
        }
        let sortByNameDescending = UIAction(
            title: "Nama (Z - A)",
            image: UIImage(systemName: "z.square"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.displayedProducts.sort(by: { ($0.name) > ($1.name) })
            _self.tableView.reloadData()
        }
        let sortByPriceAscending = UIAction(
            title: "Harga (rendah ke tinggi)",
            image: UIImage(systemName: "0.square"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.displayedProducts.sort(by: { ($0.basePrice) < ($1.basePrice) })
            _self.tableView.reloadData()
        }
        let sortByPriceDescending = UIAction(
            title: "Harga (tinggi ke rendah)",
            image: UIImage(systemName: "9.square"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.displayedProducts.sort(by: { ($0.basePrice) > ($1.basePrice) })
            _self.tableView.reloadData()
        }
        let random = UIAction(
            title: "Acak",
            image: UIImage(systemName: "arrow.triangle.swap"),
            identifier: nil
        ) { [weak self] _ in
            guard let _self = self else { return }
            _self.displayedProducts.shuffle()
            _self.tableView.reloadData()
        }
        menus.append(sortByNameAscending)
        menus.append(sortByNameDescending)
        menus.append(sortByPriceAscending)
        menus.append(sortByPriceDescending)
        menus.append(random)
        
        return menus
    }
    
    private func handleSorterButtonShowing() {
        let isSorterButtonShown: Bool = UserDefaults.standard.bool(forKey: "isHomeProductSorterShown")
        self.isShowingSorterButton = isSorterButtonShown
        if isSorterButtonShown {
            sorterButton.alpha = 1
        } else {
            sorterButton.alpha = 0
        }
    }
    
}
