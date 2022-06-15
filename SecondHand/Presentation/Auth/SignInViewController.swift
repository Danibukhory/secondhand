//
//  SignInViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 14/06/22.
//

import UIKit

final class SignInViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Masuk"
        label.font = UIFont(name:"Poppins-Bold",size:32)
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"Poppins-Regular",size:16)
        label.text = "Username"
        return label
    }()
    
    private lazy var emailTextField: SHRoundedTextfield = {
        let textField = SHRoundedTextfield()
        textField.setPlaceholder(placeholder: "Email")
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"Poppins-Regular",size:16)
        label.text = "Password"
        return label
    }()
    
    private lazy var passwordTextField: SHRoundedTextfield = {
        let textField = SHRoundedTextfield()
        textField.setPlaceholder(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
        
    private lazy var signInButton: SHDefaultButton = {
        let button = SHDefaultButton()
        button.setActiveButtonTitle(string: "Masuk")
        button.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var noAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"Poppins-Regular",size:16)
        label.text = "Belum punya akun?"
        return label
    }()
    
    private lazy var moveToSignUpPageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Daftar di sini", for: .normal)
        button.setTitleColor(UIColor.tintColor, for: .normal)
        button.titleLabel?.font = UIFont(name:"Poppins-Bold",size:18)
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(handleTextField), for: .touchUpInside)
        return button
        // give spring animation for button if needed
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    private func configure() {
        
        view.addSubviews(
            titleLabel,
            usernameLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            signInButton,
            noAccountLabel,
            moveToSignUpPageButton
        )
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            
            emailTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
            signInButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: buttonSizeType.regular.rawValue),
            
            noAccountLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            noAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
            
            moveToSignUpPageButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -11),
            moveToSignUpPageButton.leadingAnchor.constraint(equalTo: noAccountLabel.trailingAnchor, constant: 5),
            moveToSignUpPageButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    @objc func handleSignInButton() {
        
    }
    
    @objc func handleTextField() {
        
    }
    
    
}
