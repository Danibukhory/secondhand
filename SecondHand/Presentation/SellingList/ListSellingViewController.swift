//
//  ListSellingViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 20/07/22.
//

import UIKit
import Kingfisher

final class ListSellingViewController: UITableViewController {
    
    private lazy var sellerProducts: [SHSellerProductResponse]? = nil
    private lazy var sellerOrder: [SHSellerOrderResponse]? = nil
    private lazy var sellerSoldProduct: [SHSellerProductResponse]? = {
        guard let _sellerProduct = sellerProducts else { return nil }
        let soldProduct = _sellerProduct.filter { product in
            return product.status == "sold"
        }
        return soldProduct
    }()
    private lazy var userDetails: SHUserResponse? = nil
    private lazy var selectedCategory: Int = 0
    
    var loadingIndicatorProduct = UIActivityIndicatorView(style: .medium)
    var loadingIndicatorProfile = UIActivityIndicatorView(style: .medium)
    var popUpView: SHPopupView = SHPopupView(frame: .zero, popupType: .success, text: "Berhasil menyimpan info")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Daftar Jual Saya"
        self.navigationController?.navigationBar.useSHLargeTitle()

        tableView.register(SellerCardCell.self, forCellReuseIdentifier: "\(SellerCardCell.self)")
        tableView.register(MyProductCell.self, forCellReuseIdentifier: "\(MyProductCell.self)")
        tableView.separatorStyle = .none
        setupLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.getUserData { [weak self] response in
                guard let _self = self else { return }
                _self.userDetails = response
            }
            self.getDataProduct()
            self.getInterestedProduct()
            self.tableView.reloadData()
        }
    }
}

extension ListSellingViewController {
    private func setupLoadingIndicator() {
        loadingIndicatorProduct.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorProfile.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorProduct.hidesWhenStopped = true
        loadingIndicatorProfile.hidesWhenStopped = true
        loadingIndicatorProduct.startAnimating()
        loadingIndicatorProfile.startAnimating()
        
        view.addSubviews(loadingIndicatorProduct, loadingIndicatorProfile)
        
        NSLayoutConstraint.activate([
            loadingIndicatorProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicatorProduct.topAnchor.constraint(equalTo: view.topAnchor),
            
            loadingIndicatorProduct.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicatorProduct.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    private func getDataProduct() {
        let apiCall = SecondHandAPI()
        apiCall.getSellerProducts { [weak self] response, error in
            guard let _self = self else { return }
            guard let _response = response else { return }
            _self.sellerProducts = _response
            _self.tableView.reloadData()
            _self.loadingIndicatorProduct.stopAnimating()
        }
    }
    
    private func getUserData(completion: @escaping ((SHUserResponse) -> ())) {
        let apiCall = SecondHandAPI()
        let group = DispatchGroup()
        var userResponse: SHUserResponse? = nil
        defer {
            group.notify(queue: .main) {
                completion(userResponse!)
                self.loadingIndicatorProfile.stopAnimating()
            }
        }
        group.enter()
        apiCall.getUserDetails { data, error in
            userResponse = data
            group.leave()
        }
    }
    
    private func getInterestedProduct() {
        let apiCall = SecondHandAPI()
        apiCall.getSellerOrders { [weak self] response, error in
            guard let _self = self else { return }
            guard let _response = response else { return }
            _self.sellerOrder = _response
            _self.tableView.reloadData()
//            _self.loadingIndicator.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.userDetails != nil, self.sellerProducts != nil, self.sellerOrder != nil {
            return 2
        } else {
            return 0
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let ind = indexPath.row
            
            switch ind {
            case 0:
                guard let cell =  tableView.dequeueReusableCell(withIdentifier: "\(SellerCardCell.self)", for: indexPath) as? SellerCardCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                cell.fill(userDetails: userDetails)
                cell.didClickedEditButtonAction = {
                    let viewController = CompleteAccountViewController()
                    viewController.delegate = self
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(navigationController, animated: true)
                }
                return cell
            
            case 1:
                guard let cell =  tableView.dequeueReusableCell(withIdentifier: "\(MyProductCell.self)", for: indexPath) as? MyProductCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                cell.fill(productDetails: self.sellerProducts, orderDetails: self.sellerOrder)
                cell.selectedCategory = self.selectedCategory
                cell.didSelectCategory = { [weak self] index in
                    guard let _self = self, let selectedCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? MyProductCell else { return }
                    _self.selectedCategory = index
                    selectedCell.selectedCategory = _self.selectedCategory
                    selectedCell.collectionProductView.reloadData()
                }
                cell.didSelectAddProduct = {
                    let viewController = DetailProductViewController()
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(navigationController, animated: true)
                }
                cell.didSelectMyProduct = { [weak self] product in
                    guard let _self = self else { return }
                    let previewViewController = SellerPreviewViewController()
                    let imageView = UIImageView()
                    if let url = URL(string: product.imageURL ?? "") {
                        imageView.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage])
                    }
//                    imageView.load(urlString: product.imageURL!)
                    previewViewController.imageData = imageView.image
                    previewViewController.productName = product.name
                    previewViewController.productPrice = String(product.basePrice!)
                    previewViewController.productDesc = product.description
                    previewViewController.productCategory = product.categories[0]?.name
//                    previewViewController.productCategoryID = _self.category
                    previewViewController.userResponse = _self.userDetails
                    previewViewController.publishButton.isEnabled = false
                    previewViewController.publishButton.setActiveButtonTitle(string: "Produk anda sudah diterbitkan")
                    let navigationController = UINavigationController(rootViewController: previewViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.navigationController?.present(navigationController, animated: true)
                }
                cell.didSelecMyOrder = { [weak self] product in
                    guard let _self = self else { return }
                    let previewViewController = SellerPreviewViewController()
                    let imageView = UIImageView()
                    if let url = URL(string: product.imageProduct) {
                        imageView.kf.setImage(with: url, options: [.transition(.fade(0.2)), .cacheOriginalImage])
                    }
                    previewViewController.imageData = imageView.image
                    previewViewController.productName = product.productName
                    previewViewController.productPrice = String(product.basePrice)
                    previewViewController.productCategory = product.status
                    previewViewController.userResponse = _self.userDetails
                    previewViewController.publishButton.isEnabled = false
                    previewViewController.publishButton.setActiveButtonTitle(string: "Produk anda sudah diterbitkan")
                    let navigationController = UINavigationController(rootViewController: previewViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.navigationController?.present(navigationController, animated: true)
                }
                return cell
            default:
                return UITableViewCell()
            }
    }
}

extension ListSellingViewController: DidClickSaveButtonAction {
    func didClickButton(info: Bool) {
        if info {
            view.addSubview(popUpView)
            popUpView.translatesAutoresizingMaskIntoConstraints = false
            popUpView.isPresenting.toggle()
            
            NSLayoutConstraint.activate([
                popUpView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                popUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                popUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        }
    }
}
