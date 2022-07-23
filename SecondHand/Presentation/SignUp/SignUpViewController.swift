//
//  SignUpViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 14/06/22.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    let apiManager = SecondHandAPI.shared
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Daftar"
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
    
    private lazy var usernameTextField: SHRoundedTextfield = {
        let textField = SHRoundedTextfield()
        textField.autocapitalizationType = .none
        textField.setPlaceholder(placeholder: "Username")
        return textField
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
        textField.autocapitalizationType = .none
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
        textField.autocapitalizationType = .none
        textField.setForPasswordTextfield()
        textField.addTarget(self, action: #selector(handlePasswordTextChange), for: .editingChanged)
        return textField
    }()
        
    private lazy var signUpButton: SHButton = {
        let button = SHButton(frame: CGRect(), title: "Daftar", type: .filled, size: .regular)
        button.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var noAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"Poppins-Regular",size:16)
        label.text = "Sudah punya akun?"
        return label
    }()
    
    private lazy var moveToSignInPageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Masuk di sini", for: .normal)
        button.tintColor = UIColor(rgb: 0x7126B5)
        button.setTitleColor(UIColor.tintColor, for: .normal)
        button.titleLabel?.font = UIFont(name:"Poppins-Bold", size: 18)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(moveToSignInPage), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomTextContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapRecognizer()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    @objc func handleSignUpButton() {
        guard let emailText = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let usernameText = usernameTextField.text?.trimmingCharacters(in: .whitespaces),
              let passwordText = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        else { return }
        
        switch(emailText.isEmpty, usernameText.isEmpty, passwordText.isEmpty) {
        case (true,true,true):
            setupAlert(title: "Error", message: "Kolom username, email, dan password harus diisi.", style: .alert)
        case (false,true,true):
            setupAlert(title: "Error", message: "Kolom username dan password harus diisi.", style: .alert)
        case (false,false,true):
            setupAlert(title: "Error", message: "Kolom password harus diisi.", style: .alert)
        case (true,true,false):
            setupAlert(title: "Error", message: "Kolom username dan email harus diisi.", style: .alert)
        case (true,false,true):
            setupAlert(title: "Error", message: "Kolom email dan password harus diisi.", style: .alert)
        case (true,false,false):
            setupAlert(title: "Error", message: "Kolom email harus diisi.", style: .alert)
        case (false,true,false):
            setupAlert(title: "Error", message: "Kolom username harus diisi.", style: .alert)
        default:
            if emailText.isValidEmail && passwordText.isValidPassword(passwordText) {
                apiManager.signUp(
                    username: usernameText,
                    email: emailText,
                    password: passwordText
                ) { [weak self] response, error in
                    guard let _self = self, let _ = response else {
                        self?.setupAlert(title: "Error", message: "Kesalahan terjadi :(\n\(String(describing: error))", style: .alert)
                        return
                    }
                    let alert = UIAlertController(title: "Pendaftaran Berhasil!", message: "Silahkan login dengan akun baru anda.", preferredStyle: .alert)
                    alert.view.tintColor = UIColor(rgb: 0x7126B5)
                    let action = UIAlertAction(title: "Oke", style: .default) { _ in
                        _self.dismiss(animated: true)
                    }
                    alert.addAction(action)
                    _self.present(alert, animated: true)
                }
                
            } else {
                setupAlert(title: "Failed", message: "Email or Password is invalid", style: .alert)
            }
        }
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
    
    @objc func moveToSignInPage() {
        self.dismiss(animated: true)
    }
    
    private func configure() {
        view.addSubviews(
            titleLabel,
            usernameLabel,
            usernameTextField,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            signUpButton,
            bottomTextContainerView
        )
        bottomTextContainerView.addSubviews(noAccountLabel, moveToSignInPageButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            emailLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
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
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
            signUpButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            
            bottomTextContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16),
            bottomTextContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomTextContainerView.heightAnchor.constraint(equalToConstant: 36),
            bottomTextContainerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            
            noAccountLabel.centerYAnchor.constraint(equalTo: bottomTextContainerView.centerYAnchor),
            noAccountLabel.leadingAnchor.constraint(equalTo: bottomTextContainerView.leadingAnchor),
            
            moveToSignInPageButton.centerYAnchor.constraint(equalTo: bottomTextContainerView.centerYAnchor),
            moveToSignInPageButton.leadingAnchor.constraint(equalTo: noAccountLabel.trailingAnchor, constant: 4),
            moveToSignInPageButton.heightAnchor.constraint(equalToConstant: 20),
            moveToSignInPageButton.trailingAnchor.constraint(equalTo: bottomTextContainerView.trailingAnchor),
        ])
    }
    
    private func setupAlert(
        title titleAlert: String,
        message messageAlert: String,
        style styleAlert: UIAlertController.Style)
    {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: styleAlert)
        alert.addAction(UIAlertAction(title: "Oke", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupTapRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
   
    @objc private func dismissKeyboard() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        self.setEditing(false, animated: true)
    }
}
