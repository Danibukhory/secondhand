//
//  ListSellingViewController.swift
//  SecondHand
//
//  Created by Daffashiddiq on 20/07/22.
//

import UIKit

final class ListSellingViewController: UITableViewController {
    
    private lazy var sellerProducts: [SHSellerProductResponse]? = nil
    private lazy var sellerOrder: [SHSellerOrderResponse]? = nil
    private lazy var userDetails: SHUserResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SellerCardCell.self, forCellReuseIdentifier: "\(SellerCardCell.self)")
        tableView.register(MyProductCell.self, forCellReuseIdentifier: "\(MyProductCell.self)")
        tableView.separatorStyle = .none
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
    private func getDataProduct() {
        let apiCall = SecondHandAPI()
        apiCall.getSellerProducts { [weak self] response, error in
            guard let _self = self else { return }
            guard let _response = response else { return }
            _self.sellerProducts = _response
            _self.tableView.reloadData()
        }
    }
    
    private func getUserData(completion: @escaping ((SHUserResponse) -> ())) {
        let apiCall = SecondHandAPI()
        let group = DispatchGroup()
        var userResponse: SHUserResponse? = nil
        defer {
            group.notify(queue: .main) {
                completion(userResponse!)
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
                return cell
            
            case 1:
                guard let cell =  tableView.dequeueReusableCell(withIdentifier: "\(MyProductCell.self)", for: indexPath) as? MyProductCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                cell.fill(productDetails: self.sellerProducts, orderDetails: self.sellerOrder)
                cell.didSelectCategory = { [weak self] index in
                    guard let _self = self else { return }
//                    print(index)
                    cell.selectedCategory = index
                    print(cell.selectedCategory)
                    _self.tableView.reloadData()
                }
                return cell
            default:
                return UITableViewCell()
            }
    }
}
