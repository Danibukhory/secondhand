//
//  SignInViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 14/06/22.
//

import UIKit

final class SignInViewController: UIViewController {
    let signManager = SecondHandAPI.shared
    
    private var signInData: SignInResponse = SignInResponse()
    
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
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
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
        textField.autocapitalizationType = .none
        textField.setForPasswordTextfield()
        textField.addTarget(self, action: #selector(handlePasswordTextChange), for: .editingChanged)
        return textField
    }()
        
    private lazy var signInButton: SHButton = {
        let button = SHButton(frame: CGRect(), title: "Masuk", type: .filled, size: .regular)
//        button.addTarget(self, action: #selector(moveToMainView), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        button.isEnabled = false
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
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTapRecognizer()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    @objc func handleSignInButton() {
        guard let emailText = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let passwordText = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        else { return }
    
        if emailText.isValidEmail && passwordText.isValidPassword(passwordText) {
            loadingIndicator.startAnimating()
            signInButton.setActiveButtonTitle(string: "")
            signManager.signIn(email: emailText, password: passwordText) { [weak self] result, error in
                guard let _self = self else { return }
                guard let _result = result else {
                    self?.loadingIndicator.stopAnimating()
                    self?.signInButton.setActiveButtonTitle(string: "Masuk")
                    self?.setupAlert(title: "Error", message: "Email atau password salah. Coba lagi.", style: .alert)
                    return
                }
                _self.signInData.id = _result.id
                if _self.signInData.id != 0 {
                    UserDefaults.standard.set(_result.accessToken, forKey: "accessToken")
                    _self.loadingIndicator.stopAnimating()
                    _self.signInButton.setActiveButtonTitle(string: "Masuk")
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    let home = MainTabBarController()
                    _self.navigationController?.pushViewController(home, animated: true)
                }
            }
        } else {
            setupAlert(title: "Error", message: "Password tidak valid.", style: .alert)
            loadingIndicator.stopAnimating()
            signInButton.setActiveButtonTitle(string: "Masuk")
        }
        
    }
    
    @objc func moveToMainView() {
        let viewController = MainTabBarController()
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func goToMainView() {
        let viewController = MainTabBarController()
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func handleEmailTextChange() {
        guard let text = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        if text.isValidEmail {
            emailTextField.layer.borderColor = UIColor.systemGreen.cgColor
            if !password.isEmpty && password.isValidPassword(password) {
                signInButton.isEnabled = true
            }
        } else if text.isEmpty {
            emailTextField.layer.borderColor = UIColor.systemGray5.cgColor
            signInButton.isEnabled = false
        } else {
            emailTextField.layer.borderColor = UIColor.systemRed.cgColor
            signInButton.isEnabled = false
        }
    }
        
    @objc func handlePasswordTextChange() {
        guard let text = passwordTextField.text,
              let email = emailTextField.text
        else { return }
        if text.isValidPassword(text) {
            passwordTextField.layer.borderColor = UIColor.systemGreen.cgColor
            if !email.isEmpty && email.isValidEmail {
                signInButton.isEnabled = true
            }
        } else if text.isEmpty {
            passwordTextField.layer.borderColor = UIColor.systemGray5.cgColor
            signInButton.isEnabled = false
        } else {
            passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
            signInButton.isEnabled = false
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
        signInButton.addSubview(loadingIndicator)
        
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
            
            loadingIndicator.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor),
            
            noAccountLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            noAccountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
            
            moveToSignUpPageButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -11),
            moveToSignUpPageButton.leadingAnchor.constraint(equalTo: noAccountLabel.trailingAnchor, constant: 5),
            moveToSignUpPageButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func prepareTapRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        self.setEditing(false, animated: true)
    }
    
    private func setupAlert(
        title titleAlert: String,
        message messageAlert: String,
        style styleAlert: UIAlertController.Style)
    {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: styleAlert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
