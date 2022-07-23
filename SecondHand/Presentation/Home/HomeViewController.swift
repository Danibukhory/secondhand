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
    
    var refControl = UIRefreshControl()
    var searchTableView = UITableView()
    var products: [SHBuyerProductResponse] = []
    var displayedSearchedProducts: [SHBuyerProductResponse] = []
    var recentlyViewedProducts: [SHBuyerProductResponse] = []
    var searchText: String = ""
    
    private typealias rowType = HomeViewCellRowType
    
    private var signInData: SignInResponse = SignInResponse()
    
    var scrollToBottomButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.tintColor = UIColor(rgb: 0x7126B5)
        return button
    }()
    
    var isOnTop: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
        setupSearchTableView()
        setupRefreshControl()
        prepareScrollButton()
        registerCells()
        tableView.backgroundColor = UIColor(rgb: 0x7126B5)
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        let isSorterButtonShown: Bool = UserDefaults.standard.bool(forKey: "isHomeProductSorterShown")
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? HomeProductCell else { return }
        cell.isSorterButtonShown = isSorterButtonShown
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch tableView {
//        case searchTableView:
//            if searchText.isEmpty && !recentlyViewedProducts.isEmpty {
//                return "Yang anda cari sebelumnya"
//            } else if !searchText.isEmpty {
//                return nil
//            }
//            return nil
//        default:
//            return nil
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case searchTableView:
            return displayedSearchedProducts.count
        default:
            return 2
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
                }
                cell.onCategorySelectorTap = { [weak self] _category in
                    guard self != nil,
                          let productCell = tableView.cellForRow(
                            at: IndexPath(row: 1, section: 0)
                          ) as? HomeProductCell
                    else { return }
                    if _category.name == "Semua" {
                        productCell.displayedProducts = productCell.products
                    } else {
                        let filteredProducts: [SHBuyerProductResponse] = productCell.products.filter { product in
                            return product.categories.contains(where: {$0.name == _category.name})
                        }
                        productCell.displayedProducts = filteredProducts
                    }
                    productCell.collectionView.reloadData()
                    productCell.collectionView.fadeOut()
                    productCell.collectionView.fadeIn()
                    productCell.sorterButton.setActiveButtonTitle(string: "Urutkan berdasarkan: acak")
                }
                cell.onSearchBarTextChange = { [weak self] searchText in
                    guard let _self = self else { return }
                    if searchText.isEmpty {
                        _self.displayedSearchedProducts = _self.recentlyViewedProducts
                        _self.searchText = searchText
                    } else {
                        let filteredProducts: [SHBuyerProductResponse] = _self.products.filter { product in
//                            if let name = product.name.lowercased() {
//                                return name.contains(searchText.lowercased())
//                            } else {
//                                return false
//                            }
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
                
            case rowType.product.rawValue:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "\(HomeProductCell.self)",
                    for: indexPath
                ) as? HomeProductCell else {
                    let loadingCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
                    loadingCell.contentView.heightAnchor.constraint(equalToConstant: 400).isActive = true
                    return loadingCell
                }
                cell.selectionStyle = .none
                cell.onProductLoad = { [weak self] in
                    guard let _self = self else { return }
                    _self.products = cell.products
                    cell.sorterButton.fadeIn()
                    cell.loadingIndicator.stopAnimating()
                    cell.collectionView.fadeOut()
                    cell.collectionView.fadeIn()
                }
                cell.didSelectProduct = { [weak self] product in
                    guard let _self = self else { return }
                    let buyerSixVC = BuyerSixViewController()
                    buyerSixVC.buyerResponse = product
                    _self.tabBarController?.navigationController?.pushViewController(buyerSixVC, animated: true)
                }
                
                return cell
            default:
                return UITableViewCell()
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
        scrollToBottomButton.fadeOut()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToBottomButton.fadeIn()
        } else {
            scrollToBottomButton.fadeOut()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToBottomButton.fadeIn()
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
    
    private func prepareScrollButton() {
        view.addSubview(scrollToBottomButton)
        NSLayoutConstraint.activate([
            scrollToBottomButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            scrollToBottomButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            scrollToBottomButton.heightAnchor.constraint(equalToConstant: 40),
            scrollToBottomButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        scrollToBottomButton.addTarget(self, action: #selector(onScrollButtonTap), for: .touchUpInside)
    }
    
    @objc func onScrollButtonTap() {
        if isOnTop {
            tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .bottom, animated: true)
            isOnTop = false
            scrollToBottomButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        }
        else {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            isOnTop = true
            scrollToBottomButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        }
    }
    
    @objc private func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    private func registerCells() {
        tableView.register(HomeHeaderCell.self, forCellReuseIdentifier: "\(HomeHeaderCell.self)")
        tableView.register(HomeProductCell.self, forCellReuseIdentifier: "\(HomeProductCell.self)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "loadingCell")
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchHistoryCell")
        searchTableView.register(HomeSearchResultCell.self, forCellReuseIdentifier: "\(HomeSearchResultCell.self)")
    }
    
    private func setupRefreshControl() {
        refControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.refreshControl = refControl
    }
    
    @objc private func refreshPage() {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "\(HomeHeaderCell.self)", for: IndexPath(row: 0, section: 0)) as? HomeHeaderCell,
              let productCell = tableView.dequeueReusableCell(withIdentifier: "\(HomeProductCell.self)", for: IndexPath(row: 0, section: 0)) as? HomeProductCell
        else { return }
        let group = DispatchGroup()
        group.enter()
        headerCell.loadBanners()
        headerCell.loadCategories()
        productCell.loadProducts()
        group.leave()
        group.notify(queue: .main) {
            self.refControl.endRefreshing()
        }
    }
    
}
