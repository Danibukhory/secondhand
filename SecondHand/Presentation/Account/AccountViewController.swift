//
//  AccountViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 15/06/22.
//

import UIKit

final class AccountViewController: UIViewController {
    
    private lazy var signInButton: SHDefaultButton = {
        let button = SHDefaultButton()
        button.setActiveButtonTitle(string: "Masuk")
        button.addTarget(self, action: #selector(moveToSignInPage), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configure()
    }
    
    @objc func moveToSignInPage() {
        let viewController = SignInViewController()
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false) // consider to change this code in the future
        tabBarController?.tabBar.isHidden = true // consider to change this code in the future
    }
    
    private func configure() {
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: buttonSizeType.regular.rawValue),
            
            
        ])
    }

}
