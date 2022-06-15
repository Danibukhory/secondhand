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
        
        let homeViewController = HomeViewController()
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "img-sh-home-inactive"),
            selectedImage: UIImage(named: "img-sh-home-active")
        )
        
        let notificationViewController = NotificationViewController()
        notificationViewController.tabBarItem = UITabBarItem(
            title: "Notification",
            image: UIImage(named: "img-sh-bell-inactive"),
            selectedImage: UIImage(named: "img-sh-bell-active")
        )
        
        let sellingViewController = SellingViewController()
        sellingViewController.tabBarItem = UITabBarItem(
            title: "Jual",
            image: UIImage(named: "img-sh-plus-circle"),
            selectedImage: UIImage(named: "img-sh-plus-circle")
        )
        
        let sellingListViewController = SellingListViewController()
        sellingListViewController.tabBarItem = UITabBarItem(
            title: "Daftar Jual",
            image: UIImage(named: "img-sh-list-inactive"),
            selectedImage: UIImage(named: "img-sh-list-active")
        )
        
        let accountViewController = AccountViewController()
        accountViewController.tabBarItem = UITabBarItem(
            title: "Akun",
            image: UIImage(named: "img-sh-user-inactive"),
            selectedImage: UIImage(named: "img-sh-user-active")
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
