//
//  SignInViewController.swift
//  SecondHand
//
//  Created by Raden Dimas on 14/06/22.
//

import UIKit
import CoreData

final class SignInViewController: UIViewController {
    
    var signManager = SecondHandAPI.shared
    
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
        setupTapRecognizer()
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    @objc func handleSignInButton() {
        guard let emailText = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let passwordText = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        else { return }
    
        if emailText.isValidEmail && passwordText.isValidPassword(passwordText) {
            let group = DispatchGroup()
            loadingIndicator.startAnimating()
            signInButton.setActiveButtonTitle(string: "")
            DispatchQueue.main.async { [weak self] in
                guard let _self = self else { return }
                group.enter()
                _self.signManager.signIn(email: emailText, password: passwordText) { result, error in
                    guard let _result = result else {
                        self?.loadingIndicator.stopAnimating()
                        self?.signInButton.setActiveButtonTitle(string: "Masuk")
                        self?.setupAlert(title: "Error", message: "Email atau password salah. Coba lagi.", style: .alert)
                        return
                    }
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "SignedInUser", in: managedContext)!
                    let user = NSManagedObject(entity: entity, insertInto: managedContext)
                    user.setValue(_result.id, forKey: "id")
                    user.setValue(_result.fullName, forKey: "full_name")
                    user.setValue(_result.address, forKey: "address")
                    user.setValue(_result.email, forKey: "email")
                    user.setValue(_result.password, forKey: "password")
                    user.setValue(_result.phoneNumber, forKey: "phone_number")
                    user.setValue(_result.city, forKey: "city")
                    user.setValue(_result.imageURL, forKey: "image_url")
                    user.setValue(_result.createdAt, forKey: "createdAt")
                    user.setValue(_result.updatedAt, forKey: "updatedAt")
                    do {
                      try managedContext.save()
                    } catch let error as NSError {
                      print("Could not save. \(error), \(error.userInfo)")
                    }
                    _self.dismiss(animated: true)
                    UserDefaults.standard.set(true, forKey: "isSignedIn")
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
    
    private func setupAlert(
        title titleAlert: String,
        message messageAlert: String,
        style styleAlert: UIAlertController.Style)
    {
        let alert = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: styleAlert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveSignedInUser(_ data: SHUserResponse) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SignedInUser", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(data.fullName, forKey: "full_name")
        user.setValue(data.id, forKey: "id")
        user.setValue(data.password, forKey: "password")
        user.setValue(data.imageURL, forKey: "image_url")
        user.setValue(data.address, forKey: "address")
        user.setValue(data.city, forKey: "city")
        user.setValue(data.phoneNumber, forKey: "phone_number")
        user.setValue(data.createdAt, forKey: "createdAt")
        user.setValue(data.updatedAt, forKey: "updatedAt")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func setupNavigationBar() {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(dismissView))
        button.tintColor = .black
        navigationItem.leftBarButtonItem = button
    }
    
    @objc private func dismissView() {
        self.navigationController?.dismiss(animated: true)
    }
    
}
