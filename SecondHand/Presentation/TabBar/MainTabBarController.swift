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
            title: "Notifikasi",
            image: UIImage(named: "img-sh-bell-inactive")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "img-sh-bell-active")?.withRenderingMode(.alwaysTemplate)
        )
        
        let sellingViewController = DetailProductViewController()
        sellingViewController.tabBarItem = UITabBarItem(
            title: "Jual",
            image: UIImage(named: "img-sh-plus-circle")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "img-sh-plus-circle")?.withRenderingMode(.alwaysTemplate)
        )
                
        let sellingListViewController = ListSellingViewController()
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
            return navigationController
        }
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(rgb: 0x7126B5)
        self.viewControllers = viewControllers
    }
    
    func showSignInAlert() {
        let alertController = UIAlertController(
            title: "Masuk",
            message: "Anda harus masuk terlebih dahulu untuk menggunakan fitur ini.",
            preferredStyle: .alert
        )
        alertController.view.tintColor = UIColor(rgb: 0x7126B5)
        let signInAction = UIAlertAction(title: "Masuk", style: .default) { _ in
            let vc = SignInViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen
//            self.tabBarController?.navigationController?.present(navigationController, animated: true)
            self.navigationController?.present(navigationController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Nanti", style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(signInAction)
        self.present(alertController, animated: true)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        if viewController == tabBarController.viewControllers?[2] {
            if isSignedIn {
                let viewController = DetailProductViewController()
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.navigationController?.present(navigationController, animated: true)
                return false
            } else {
                showSignInAlert()
                return false
            }
        }
        if viewController == tabBarController.viewControllers?[3] {
            if isSignedIn {
                return true
            } else {
                showSignInAlert()
                return false
            }
        }
        return true
    }
}
