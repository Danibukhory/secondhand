//
//  OffererViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 20/06/22.
//

import UIKit

final class OffererViewController: UITableViewController {
    
    var popupView: SHPopupView?
    var user: SHUserResponse
    var buyerName: String?
    var notification: SHNotificationResponse?
    var api = SecondHandAPI.shared
    var order: SHSellerOrderResponse?
    var loadingView: UIView = {
        let _view = UIView()
        _view.backgroundColor = .white
        let loadingIndicator = UIActivityIndicatorView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        _view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: _view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: _view.centerYAnchor)
        ])
        return _view
    }()
    
    enum OffererViewCellSectionType: Int {
        case offerer = 0
        case product = 1
    }
    
    private typealias sectionType = OffererViewCellSectionType
    
    init(user: SHUserResponse, notification: SHNotificationResponse?) {
        self.user = user
        self.notification = notification
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        setupLoadingView()
        loadOrders()
        setupNavigationBar()
        setupPopupView()
        tableView.register(OffererDetailCell.self, forCellReuseIdentifier: "\(OffererDetailCell.self)")
        tableView.register(OffererProductCell.self, forCellReuseIdentifier: "\(OffererProductCell.self)")
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case 1:
            return "Daftar produkmu yang ditawar"

        default:
            return nil
        }
    }
    
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
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
            cell.fill(with: user)
            cell.offererNameLabel.setTitle(text: buyerName ?? "", size: 14, weight: .medium, color: .black)
            cell.selectionStyle = .none
            return cell
            
        case sectionType.product.rawValue:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(OffererProductCell.self)", for: indexPath
            ) as? OffererProductCell,
                  let _notification = notification
            else {
                return UITableViewCell()
            }
            cell.fill(with: _notification)
            cell.selectionStyle = .none
            cell.onRejectButtonTap = { [weak self] in
                guard let _self = self,
                      let _order = self?.order
                else { return }
                switch cell.rejectButton.currentAttributedTitle?.string {
                case "Tolak":
                    _self.popupView?.isPresenting = true
                    _self.popupView?.backgroundColor = .systemRed
                    _self.api.patchSellerOrderStatus(to: .declined, orderId: _order.id)
                case "Status":
                    let viewController = RenewTransactionStatusViewController()
                    viewController.changeDefaultHeight(to: (UIScreen.main.bounds.height / 2) - 60)
                    viewController.changeMaximumHeight(to: viewController.defaultHeight)
                    viewController.modalPresentationStyle = .overCurrentContext
                    viewController.onSendButtonTap = {
                        if viewController.isCanceled {
                            _self.api.patchSellerOrderStatus(to: .declined, orderId: _order.id)
                        } else {
                            _self.api.patchSellerOrderStatus(to: .accepted, orderId: _order.id)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            _self.popupView?.backgroundColor = UIColor(rgb: 0x73CA5C)
                            _self.popupView?.isPresenting = true
                        }
                    }
                    _self.tabBarController?.navigationController?.present(viewController, animated: false)
                default:
                    return
                }
            }
                
            cell.onAcceptButtonTap = { [weak self] in
                guard let _self = self else { return }
                let viewController = OfferAcceptedViewController()
                let buyerCell = tableView.dequeueReusableCell(withIdentifier: "\(OffererDetailCell.self)") as! OffererDetailCell
                let productNameText = cell.productNameLabel.attributedText
                let productValue = _self.notification?.bidPrice
                buyerCell.fill(with: _self.user)
                viewController.buyerImageView.image = buyerCell.offererImageView.image
                viewController.buyerNameLabel.setTitle(
                    text: _self.buyerName ?? "",
                    size: 14,
                    weight: .medium,
                    color: .black
                )
                viewController.buyerCityLabel = buyerCell.offererCityLabel
                viewController.productImageView.image = cell.productImageView.image
                viewController.productNameLabel.attributedText = productNameText
                viewController.productValueLabel.setTitle(
                    text: "Ditawar \(productValue?.convertToCurrency() ?? "")",
                    size: 14,
                    weight: .regular,
                    color: .black
                )
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.changeDefaultHeight(to: (UIScreen.main.bounds.height / 2) + 30)
                _self.tabBarController?.navigationController?.present(
                    viewController,
                    animated: false,
                    completion: {
                    cell.rejectButton.setActiveButtonTitle(string: "Status")
                    cell.acceptButton.setActiveButtonTitle(string: "Hubungi")
                })
                if cell.acceptButton.attributedTitle(for: .normal)?.string == "Terima" {
                    guard let _order = _self.order else { return }
                    _self.api.patchSellerOrderStatus(to: .accepted, orderId: _order.id)
                } else {
                    
                }
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 1:
            return
        default:
            return
        }
    }
    
    private func setupNavigationBar() {
        title = "Info Penawar"
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.heightAnchor.constraint(equalTo: view.heightAnchor),
            loadingView.widthAnchor.constraint(equalTo: view.widthAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupPopupView() {
        popupView = SHPopupView(
            frame: CGRect(),
            popupType: .success,
            text: "Status produk berhasil diperbarui"
        )
        view.addSubview(popupView!)
        popupView?.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        popupView?.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor).isActive = true
        popupView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupView?.isPresenting = false
        popupView?.onDismissButtonTap = { [weak self] in
            guard let _self = self else { return }
            _self.popupView?.isPresenting = false
        }
    }
    
    private func prepareCustomModalVC(viewController: SHModalViewController) {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadOrders() {
        api.getSellerOrders { [weak self] result, error in
            DispatchQueue.main.async {
                guard let _self = self,
                      let _result = result
                else { return }
                let filteredOrder = _result.filter { order in
                    return order.productID == _self.notification?.productID && order.price == _self.notification?.bidPrice
                }
                guard !filteredOrder.isEmpty else { return }
                _self.order = filteredOrder[0]
                _self.loadingView.fadeOut()
                print(_self.order)
            }
        }
    }
}

