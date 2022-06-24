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
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"Poppins-Regular",size:16)
        label.text = "Email"
        return label
    }()
    
    private lazy var emailTextField: SHRoundedTextfield = {
        let textField = SHRoundedTextfield()
        textField.setPlaceholder(placeholder: "Email")
        textField.addTarget(self, action: #selector(handleEmailTextChange), for: .editingChanged)
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
        textField.setForPasswordTextfield()
        textField.addTarget(self, action: #selector(handlePasswordTextChange), for: .editingChanged)
        return textField
    }()
        
    private lazy var signInButton: SHButton = {
        let button = SHButton(frame: CGRect(), title: "Masuk", type: .filled, size: .regular)
        button.addTarget(self, action: #selector(moveToMainView), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(moveToSignUpPage), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    @objc func handleSignInButton() {
        guard let emailText = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let passwordText = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        else { return }
    
        switch(emailText.isEmpty,passwordText.isEmpty) {
        case (true,true):
            setupAlert(title: "Error", message: "Please Input Username & Password!", style: .alert)

        case (true, false) :
            setupAlert(title: "Error", message: "Please Input Username!", style: .alert)

        case (false, true) :
            setupAlert(title: "Error", message: "Please Input Password!", style: .alert)

        default:
            if emailText.isValidEmail && passwordText.isValidPassword(passwordText) {
                setupAlert(title: "Success", message: "Success Sign In", style: .alert)

            } else {
                setupAlert(title: "Error", message: "Password is not valid", style: .alert)
            }
        }
    }
    
    @objc func moveToMainView() {
        let viewController = MainTabBarController()
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func handleEmailTextChange() {
        guard let text = emailTextField.text else {
            return
        }
        if text.isValidEmail {
            emailTextField.layer.borderColor = UIColor.systemGreen.cgColor
        } else if text.isEmpty {
            emailTextField.layer.borderColor = UIColor.systemGray5.cgColor
        } else {
            emailTextField.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
        
    @objc func handlePasswordTextChange() {
        guard let text = passwordTextField.text else {
            return
        }
        if text.isValidPassword(text) {
            passwordTextField.layer.borderColor = UIColor.systemGreen.cgColor
        } else if text.isEmpty{
            passwordTextField.layer.borderColor = UIColor.systemGray5.cgColor
        } else {
            passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    @objc func moveToSignUpPage() {
        let viewController = UINavigationController(rootViewController: SignUpViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    
    private func configure() {
        view.addSubviews(
            titleLabel,
            emailLabel,
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
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
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
            
            noAccountLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            noAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
            
            moveToSignUpPageButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -11),
            moveToSignUpPageButton.leadingAnchor.constraint(equalTo: noAccountLabel.trailingAnchor, constant: 5),
            moveToSignUpPageButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setupAlert(
        title titleAlert: String,
        message messageAlert: String,
        style styleAlert: UIAlertController.Style)
    {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: styleAlert)
        alert.addAction(UIAlertAction(title: "OKE", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
