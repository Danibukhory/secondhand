//
//  OffererViewController.swift
//  SecondHand
//
//  Created by Bagas Ilham on 20/06/22.
//

import UIKit
import Alamofire
import Kingfisher

final class OffererViewController: UITableViewController {
    
    var popupView: SHPopupView?
    var buyer: SHOrderBuyer?
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
    
    init(notification: SHNotificationResponse?) {
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
        loadOrder()
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
            if let user = buyer {
                cell.fill(with: user)
            }
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
            cell.onDeclineButtonTap = { [weak self] in
                guard let _self = self,
                      let _order = self?.order
                else { return }
                switch cell.declineButton.currentAttributedTitle?.string {
                case "Tolak":
                    cell.declineButtonLoadingView.startAnimating()
                    cell.declineButton.setActiveButtonTitle(string: "")
                    _self.api.patchSellerOrderStatus(to: .declined, orderId: _order.id) { result, error in
                        guard result != nil else {
                            _self.popupView?.changeTextLabelString(to: "Status penawaran gagal diperbarui")
                            _self.popupView?.isPresenting = true
                            cell.declineButtonLoadingView.stopAnimating()
                            cell.declineButton.setActiveButtonTitle(string: "Tolak")
                            return
                        }
                        _self.popupView?.changeTextLabelString(to: "Status penawaran produk berhasil diperbarui menjadi: ditolak")
                        _self.popupView?.isPresenting = true
                        cell.declineButtonLoadingView.stopAnimating()
                        cell.declineButton.fadeOut()
                        cell.acceptButton.fadeOut()
                        cell.offerRejectedButton.fadeIn()
                    }
                    
                case "Status":
                    let viewController = RenewTransactionStatusViewController()
                    viewController.changeDefaultHeight(to: (UIScreen.main.bounds.height / 2) - 60)
                    viewController.changeMaximumHeight(to: viewController.defaultHeight)
                    viewController.modalPresentationStyle = .overCurrentContext
                    viewController.onSendButtonTap = {
                        if viewController.isCanceled {
                            cell.declineButton.fadeOut()
                            cell.acceptButton.fadeOut()
                            cell.outerLoadingView.startAnimating()
                            _self.api.patchSellerOrderStatus(to: .bid, orderId: _order.id) { result, error in
                                guard result != nil else {
                                    _self.popupView?.changeTextLabelString(to: "Status penawaran gagal diperbarui")
                                    _self.popupView?.isPresenting = true
                                    cell.outerLoadingView.stopAnimating()
                                    cell.declineButton.fadeIn()
                                    cell.acceptButton.fadeIn()
                                    return
                                }
                                _self.popupView?.changeTextLabelString(to: "Status penawaran produk berhasil diperbarui menjadi: ditawar")
                                _self.popupView?.isPresenting = true
                                cell.outerLoadingView.stopAnimating()
                                cell.declineButton.fadeIn()
                                cell.acceptButton.fadeIn()
                                cell.declineButton.setActiveButtonTitle(string: "Tolak")
                                cell.acceptButton.setActiveButtonTitle(string: "Terima")
                            }
                        } else {
                            _self.api.patchSellerOrderStatus(to: .accepted, orderId: _order.id) { result, error in
                                _self.popupView?.changeTextLabelString(to: "Status penawaran produk berhasil diperbarui menjadi: diterima")
                                _self.popupView?.isPresenting = true
                            }
                        }
                    }
                    _self.tabBarController?.navigationController?.present(viewController, animated: false)
                default:
                    return
                }
            }
                
            cell.onAcceptButtonTap = { [weak self] in
                guard let _self = self else { return }
                if cell.acceptButton.attributedTitle(for: .normal)?.string == "Terima" {
                    cell.acceptButton.setActiveButtonTitle(string: "")
                    cell.acceptButtonLoadingView.startAnimating()
                    _self.api.patchSellerOrderStatus(to: .accepted, orderId: _self.order?.id ?? 0) { result, error in
                        _self.popupView?.changeTextLabelString(to: "Status penawaran produk berhasil diperbarui menjadi: diterima")
                        _self.popupView?.isPresenting = true
                        if result != nil {
                            cell.acceptButtonLoadingView.stopAnimating()
                            let viewController = AcceptedOfferViewController()
                            let buyerCell = tableView.dequeueReusableCell(withIdentifier: "\(OffererDetailCell.self)") as! OffererDetailCell
                            let productNameText = cell.productNameLabel.attributedText
                            let productValue = _self.notification?.bidPrice
                            if let _buyer = _self.buyer {
                                buyerCell.fill(with: _buyer)
                            }
                            viewController.buyerImageView.image = buyerCell.offererImageView.image
                            viewController.buyerNameLabel.setTitle(
                                text: _self.buyer?.fullName ?? "Nama pembeli tidak tersedia",
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
                                cell.declineButton.setActiveButtonTitle(string: "Status")
                                cell.acceptButton.setActiveButtonTitle(string: "Hubungi")
                            })
                        }
                    }
                } else {
                    _self.popupView?.changeTextLabelString(to: "Membuka WhatsApp...")
                    _self.popupView?.backgroundColor = UIColor(rgb: 0x73CA5C)
                    _self.popupView?.isPresenting = true
                }
            }
            cell.onSoldButtonTap = { [weak self] in
                guard let _self = self else { return }
                let alertController = UIAlertController(
                    title: "Produk Sudah Terjual",
                    message: "Produk ini sudah terjual kepada pembeli lain. Jika anda ingin membatalkan penjualan kepada pembeli yang sudah anda setujui, buka halaman order pembeli tersebut dan batalkan penjualan.",
                    preferredStyle: .alert
                )
                let alertAction = UIAlertAction(title: "Oke", style: .default)
                alertController.view.tintColor = .systemIndigo
                alertController.addAction(alertAction)
                _self.present(alertController, animated: true)
            }
            cell.onOfferRejectedButtonTap = { [weak self] in
                guard let _self = self else { return }
                let alertController = UIAlertController(
                    title: "Penawaran Sudah Ditolak",
                    message: "Penawaran ini sudah anda tolak. Tinjau ulang penawaran ini?",
                    preferredStyle: .alert
                )
                let cancel = UIAlertAction(title: "Batal", style: .cancel)
                let review = UIAlertAction(title: "Tinjau", style: .destructive) { _ in
                    cell.offerRejectedButton.fadeOut()
                    cell.outerLoadingView.startAnimating()
                    guard let orderId = _self.order?.id else { return }
                    _self.api.patchSellerOrderStatus(to: .bid, orderId: orderId) { result, error in
                        guard result != nil else {
                            _self.popupView?.changeTextLabelString(to: "Status penawaran gagal diperbarui")
                            _self.popupView?.isPresenting = true
                            cell.outerLoadingView.stopAnimating()
                            cell.offerRejectedButton.fadeIn()
                            return
                        }
                        _self.popupView?.changeTextLabelString(to: "Status penawaran produk berhasil diperbarui menjadi: ditawar")
                        _self.popupView?.isPresenting = true
                        cell.outerLoadingView.stopAnimating()
                        cell.declineButton.fadeIn()
                        cell.acceptButton.fadeIn()
                        cell.declineButton.setActiveButtonTitle(string: "Tolak")
                        cell.acceptButton.setActiveButtonTitle(string: "Terima")
                    }
                }
                alertController.view.tintColor = .systemIndigo
                alertController.addAction(cancel)
                alertController.addAction(review)
                _self.present(alertController, animated: true)
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
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
        navigationItem.leftBarButtonItem = button
    }
    
    @objc private func dismissView() {
        self.navigationController?.popViewController(animated: true)
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
    
    private func loadOrder() {
        DispatchQueue.main.async { [self] in
            api.renewAccessToken()
            api.getSellerOrder(orderId: self.notification?.orderID ?? 0) { [weak self] result, error in
                guard let _self = self,
                      let _result = result
                else {
                    if let _error = error, _error.responseCode == 404 {
                        let alertController = UIAlertController(title: "Error", message: "Terjadi kesalahan :(\nOrder tidak ditemukan.", preferredStyle: .alert)
                        let dismiss = UIAlertAction(title: "Kembali", style: .destructive) { [weak self] _ in
                            guard let _self = self else { return }
                            _self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(dismiss)
                        self?.present(alertController, animated: true)
                        return
                    }
                    return
                }
                _self.order = _result
                _self.buyer = _result.buyer
                guard let cell = _self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? OffererProductCell else { return }
                if _result.status == "accepted" {
                    cell.declineButton.setActiveButtonTitle(string: "Status")
                    cell.acceptButton.setActiveButtonTitle(string: "Hubungi")
                } else if _result.status == "declined" {
                    cell.declineButton.alpha = 0
                    cell.acceptButton.alpha = 0
                    cell.offerRejectedButton.fadeIn()
                }
                else if _result.product.status == "sold" {
                    cell.declineButton.alpha = 0
                    cell.acceptButton.alpha = 0
                    cell.productSoldButton.fadeIn()
                }
                else {
                    cell.declineButton.setActiveButtonTitle(string: "Tolak")
                    cell.acceptButton.setActiveButtonTitle(string: "Terima")
                }
                _self.loadingView.fadeOut()
                _self.tableView.reloadData()
            }
        }
    }
}

