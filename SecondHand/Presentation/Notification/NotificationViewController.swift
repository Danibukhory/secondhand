//
//  NotificationViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import UIKit

final class NotificationViewController: UITableViewController {
    
    var numberOfNotifications: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "\(NotificationCell.self)")
        title = "Notifikasi"
        navigationController?.navigationBar.useSHLargeTitle()
        view.backgroundColor = .systemBackground
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfNotifications
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(NotificationCell.self)",
            for: indexPath
        ) as? NotificationCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SignInViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
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
                _self.numberOfNotifications -= 1
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
    

}
