//
//  MainTabBarController.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "img-sh-home-inactive")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "img-sh-home-active")?.withRenderingMode(.alwaysTemplate)
        )
        
        let notificationViewController = NotificationViewController()
        notificationViewController.tabBarItem = UITabBarItem(
            title: "Notification",
            image: UIImage(named: "img-sh-bell-inactive")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "img-sh-bell-active")?.withRenderingMode(.alwaysTemplate)
        )
        
        let sellingViewController = DetailProductViewController()
        sellingViewController.tabBarItem = UITabBarItem(
            title: "Jual",
            image: UIImage(named: "img-sh-plus-circle")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "img-sh-plus-circle")?.withRenderingMode(.alwaysTemplate)
        )
                
        let sellingListViewController = SellingListPageViewController()
        sellingListViewController.tabBarItem = UITabBarItem(
            title: "Daftar Jual",
            image: UIImage(named: "img-sh-list-inactive")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "img-sh-list-active")?.withRenderingMode(.alwaysTemplate)
        )
        
        let accountViewController = AccountTableViewController()
        accountViewController.tabBarItem = UITabBarItem(
            title: "Akun",
            image: UIImage(named: "img-sh-user-inactive")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "img-sh-user-active")?.withRenderingMode(.alwaysTemplate)
        )
        
        let viewControllers: [UINavigationController] = [
            homeViewController,
            notificationViewController,
            sellingViewController,
            sellingListViewController,
            accountViewController
        ].map {
            let navigationController = UINavigationController(rootViewController: $0)
//            navigationController.navigationBar.prefersLargeTitles = true
//            navigationController.navigationItem.largeTitleDisplayMode = .always
//            navigationController.navigationBar.tintColor = .white
            return navigationController
        }
    
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(rgb: 0x7126B5)
        self.viewControllers = viewControllers
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[2] {
            let vc = DetailProductViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
}
