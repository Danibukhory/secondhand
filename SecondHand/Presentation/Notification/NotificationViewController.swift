//
//  NotificationViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import UIKit

final class NotificationViewController: UITableViewController {
    
    var notifications: [SHNotificationResponse] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .white
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "\(NotificationCell.self)")
        title = "Notifikasi"
        navigationController?.navigationBar.useSHLargeTitle()
        view.backgroundColor = .systemBackground
        loadNotification()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let row = indexPath.row
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let notification = notifications[row]
        guard let user = notification.user,
              let product = notification.product
        else { return }
        let viewController = OffererViewController(user: user, product: product)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
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
        let item = UIContextualAction(
            style: .normal,
            title: "Mark As Read"
        ) { action, view, completion in
            let ac = UIAlertController(
                title: "Mark Notification As Read",
                message: "Are you sure want to mark this notification as read?",
                preferredStyle: .alert)
            
            let markAsRead = UIAlertAction(
                title: "Mark As Read",
                style: .default
            ) { _ in
                cell.isRead = true
                let notificationId = self.notifications[row].id
                let api = SecondHandAPI()
                api.setNotificationAsRead(notificationId: "\(notificationId ?? 0)")
                completion(true)
            }
            
            let cancel = UIAlertAction(
                title: "Cancel",
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
            guard let _self = self else { return }
            _self.notifications = result?.sorted(by: {$0.transactionDate ?? "" < $1.transactionDate ?? ""}) ?? []
            _self.tableView.reloadData()
        }
    }
}
