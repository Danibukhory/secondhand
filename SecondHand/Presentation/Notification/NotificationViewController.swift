//
//  NotificationViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import UIKit

final class NotificationViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var notifications: [SHNotificationResponse] = []
    var refControl = UIRefreshControl()
    var loadingIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    var isAlreadyLoading: Bool = false {
        didSet {
            loadingIndicator.stopAnimating()
        }
    }
    var api = SecondHandAPI.shared
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.loadNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "\(NotificationCell.self)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        title = "Notifikasi"
        navigationController?.navigationBar.useSHLargeTitle()
        view.backgroundColor = .systemBackground
        setupRefreshControl()
        loadNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !notifications.isEmpty {
            return notifications.count
        } else {
            return 1
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let row = indexPath.row
        switch notifications.count {
        case 0:
            guard isAlreadyLoading else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            cell.selectionStyle = .none
            var config = cell.defaultContentConfiguration()
            config.attributedText = NSAttributedString(string: "Tidak ada notifikasi.", attributes: [.font : UIFont(name: "Poppins-Regular", size: 14)!])
            cell.contentConfiguration = config
            return cell
        default:
            let notification = notifications[row]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(NotificationCell.self)",
                for: indexPath
            ) as? NotificationCell else {
                return UITableViewCell()
            }
            cell.fill(with: notification)
            if notification.read ?? false {
                cell.isRead = true
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch notifications.count {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
            return
        default:
            let notification = notifications[row]
            switch notification.status {
            case "bid":
                guard let user = notification.user else { return }
                let viewController = OffererViewController(user: user, notification: notification)
                viewController.buyerName = notification.buyerName
                navigationController?.pushViewController(viewController, animated: true)
            case "create":
                guard let productId = notification.productID else { return }
                api.getBuyerProductDetail(itemId: "\(productId)") { [weak self] result, error in
                    guard let _self = self,
                          let _result = result
                    else {
                        if let _error = error {
                            let alertController = UIAlertController(title: "Error", message: "Terjadi kesalahan :(\n\nResponse: \(String(describing: _error))", preferredStyle: .alert)
                            let dismiss = UIAlertAction(title: "Kembali", style: .destructive)
                            alertController.addAction(dismiss)
                            self?.tableView.deselectRow(at: indexPath, animated: true)
                            self?.navigationController?.present(alertController, animated: true)
                        }
                        return
                    }
                    let viewController = BuyerSixViewController()
                    viewController.buyerResponse = _result
                    _self.tabBarController?.navigationController?.pushViewController(viewController, animated: true)
                }
            default:
                let viewController = NotificationDetailViewController(notification: notification, style: .insetGrouped)
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard !notifications.isEmpty else { return nil }
        let row = indexPath.row
        let item = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { action, view, completion in
            let ac = UIAlertController(
                title: "Delete Notification",
                message: "Are you sure want to delete this notification?",
                preferredStyle: .alert)
            
            let delete = UIAlertAction(
                title: "Delete",
                style: .destructive
            ) { [weak self] _ in
                guard let _self = self else { return }
                _self.notifications.remove(at: row)
                _self.tableView.deleteRows(
                    at: [indexPath],
                    with: .top
                )
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 1
                ) {
                    completion(true)
                    tableView.reloadData()
                }
            }
            
            let cancel = UIAlertAction(
                title: "Cancel",
                style: .cancel
            ) { _ in
                completion(true)
            }
            
            ac.addAction(cancel)
            ac.addAction(delete)
            
            self.present(ac, animated: true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        return swipeActions
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? NotificationCell else {
            return nil
        }
        let row = indexPath.row
//        let notification = notifications[row]
        let read = cell.isRead
        let actionTitle: String = {
            if read {
                return "Tandai belum dibaca"
            } else {
                return "Tandai sudah dibaca"
            }
        }()
        let item = UIContextualAction(
            style: .normal,
            title: actionTitle
        ) { action, view, completion in
            let api = SecondHandAPI.shared
            let alertTitle: String = {
                if read {
                    return "Tandai Notifikasi Belum Dibaca"
                } else {
                    return "Tandai Notifikasi Sudah Dibaca"
                }
            }()
            let alertMessage: String = {
                if read {
                    return "Apakah anda yakin ingin menandai notifikasi ini belum dibaca?"
                } else {
                    return "Apakah anda yakin ingin menandai notifikasi ini sudah dibaca?"
                }
            }()
            let ac = UIAlertController(
                title: alertTitle,
                message: alertMessage,
                preferredStyle: .alert
            )
            
            let markAsRead = UIAlertAction(
                title: actionTitle,
                style: .default
            ) { _ in
                if read {
                    cell.isRead = false
                    completion(true)
                } else {
                    cell.isRead = true
                    let notificationId = self.notifications[row].id
                    api.setNotificationAsRead(notificationId: "\(notificationId ?? 0)")
                    completion(true)
                }
            }
            
            let cancel = UIAlertAction(
                title: "Batal",
                style: .cancel
            ) { _ in
                completion(true)
            }
            
            ac.addAction(cancel)
            ac.addAction(markAsRead)
            
            self.present(ac, animated: true)
        }
        item.backgroundColor = .systemCyan
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        return swipeActions
    }
    
    private func loadNotification() {
        let api = SecondHandAPI()
        api.getNotifications { [weak self] result, error in
            guard let _self = self else {
                let alert = UIAlertController(title: "Error", message: "Failed to fetch notifications.", preferredStyle: .alert)
                alert.view.tintColor = UIColor(rgb: 0x7126B5)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self?.present(alert, animated: true)
                self?.loadingIndicator.stopAnimating()
                return
            }
            DispatchQueue.main.async {
                _self.notifications = result?.sorted(by: {$0.transactionDate ?? "" > $1.transactionDate ?? ""}) ?? []
                _self.isAlreadyLoading = true
                _self.tableView.reloadData()
            }
        }
        self.refControl.endRefreshing()
    }
    
    private func setupRefreshControl() {
        refControl.addTarget(self, action: #selector(refreshNotification), for: .valueChanged)
        self.refreshControl = refControl
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
    }
    
    @objc private func refreshNotification() {
        DispatchQueue.main.async {
            self.loadNotification()
        }
    }
}
