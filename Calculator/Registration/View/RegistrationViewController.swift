//
//  RegistrationViewController.swift
//  Calculator
//
//  Created by Роман on 27.07.2022.
//

import UIKit
import FirebaseAuth
import RxCocoa

class RegistrationViewController: UIViewController {
  
  var viewModel: RegistrationViewModelProtocol?
  
  private let registrationButton = UIButton()
  
  private let userNameTExtField = UITextField()
  private let emailTextField = UITextField()
  private let passwordTextField = UITextField()
  private let conformPasswprdTExtField = UITextField()
  private let loadingView = UIActivityIndicatorView(style: .large)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
}

extension RegistrationViewController {
  
  private func setup() {
    
    view.backgroundColor = .main
    
    emailTextField.delegate = self
    userNameTExtField.delegate = self
    passwordTextField.delegate = self
    conformPasswprdTExtField.delegate = self
    
    addSubViews()
    setupKeyboardSettings()
    setupRegistrationButton()
    setupLoginTextField()
    setupUserNameTextField()
    setupPasswordTextField()
    setupConformPasswordTextField()
    setupConstraints()
  }
  
  private func addSubViews() {
    
    [registrationButton, emailTextField, userNameTExtField, passwordTextField, conformPasswprdTExtField, loadingView].forEach {
      
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupKeyboardSettings() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  private func setupRegistrationButton() {
    
    registrationButton.setTitle(Strings.shared.registrtionBttonString, for: .normal)
    registrationButton.backgroundColor = .registration
    registrationButton.setTitleColor(.white, for: .normal)
    registrationButton.layer.cornerRadius = 8.0
    registrationButton.addTarget(self, action: #selector(didRegistrationButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupLoginTextField() {
    
    emailTextField.placeholder = Strings.shared.loginPlaceholderString
    emailTextField.font = .systemFont(ofSize: 15)
    emailTextField.borderStyle = .roundedRect
    emailTextField.autocorrectionType = .no
    emailTextField.keyboardType = .default
    emailTextField.returnKeyType = .done
    emailTextField.clearButtonMode = .whileEditing
    emailTextField.contentVerticalAlignment = .center
    emailTextField.layer.cornerRadius = 8.0
    emailTextField.autocapitalizationType = .none
  }
  
  private func setupUserNameTextField() {
    
    userNameTExtField.placeholder = Strings.shared.userNamePlaceholerString
    userNameTExtField.font = .systemFont(ofSize: 15)
    userNameTExtField.borderStyle = .roundedRect
    userNameTExtField.autocorrectionType = .no
    userNameTExtField.keyboardType = .default
    userNameTExtField.returnKeyType = .done
    userNameTExtField.clearButtonMode = .whileEditing
    userNameTExtField.contentVerticalAlignment = .center
    userNameTExtField.layer.cornerRadius = 8.0
    userNameTExtField.autocapitalizationType = .none
  }
  
  private func setupPasswordTextField() {
    
    passwordTextField.placeholder = Strings.shared.passwordPlaceholderString
    passwordTextField.font = .systemFont(ofSize: 15)
    passwordTextField.borderStyle = .roundedRect
    passwordTextField.autocorrectionType = .no
    passwordTextField.keyboardType = .default
    passwordTextField.returnKeyType = .done
    passwordTextField.clearButtonMode = .whileEditing
    passwordTextField.contentVerticalAlignment = .center
    passwordTextField.layer.cornerRadius = 8.0
    passwordTextField.isSecureTextEntry = true
    passwordTextField.autocapitalizationType = .none
  }
  
  private func setupConformPasswordTextField() {
    
    conformPasswprdTExtField.placeholder = Strings.shared.conformPasswordPlaceholderString
    conformPasswprdTExtField.font = .systemFont(ofSize: 15)
    conformPasswprdTExtField.borderStyle = .roundedRect
    conformPasswprdTExtField.autocorrectionType = .no
    conformPasswprdTExtField.keyboardType = .default
    conformPasswprdTExtField.returnKeyType = .done
    conformPasswprdTExtField.clearButtonMode = .whileEditing
    conformPasswprdTExtField.contentVerticalAlignment = .center
    conformPasswprdTExtField.layer.cornerRadius = 8.0
    conformPasswprdTExtField.isSecureTextEntry = true
    conformPasswprdTExtField.autocapitalizationType = .none
  }
  
  private func setupConstraints() {
    
    registrationButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    registrationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    registrationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    registrationButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    
    emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 2).isActive = true
    emailTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.frame.size.width / 8).isActive = true
    emailTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.frame.size.width / 8).isActive = true
    emailTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
    userNameTExtField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
    userNameTExtField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.frame.size.width / 8).isActive = true
    userNameTExtField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.frame.size.width / 8).isActive = true
    userNameTExtField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
    passwordTextField.topAnchor.constraint(equalTo: userNameTExtField.bottomAnchor, constant: 5).isActive = true
    passwordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.frame.size.width / 8).isActive = true
    passwordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.frame.size.width / 8).isActive = true
    passwordTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
    conformPasswprdTExtField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
    conformPasswprdTExtField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.frame.size.width / 8).isActive = true
    conformPasswprdTExtField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.frame.size.width / 8).isActive = true
    conformPasswprdTExtField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
    loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
  
  @objc private func didRegistrationButtonTapped(_ sender: Any) {
    
    self.view.endEditing(true)
    
    guard let email = emailTextField.text, let username = userNameTExtField.text, let password = passwordTextField.text, let conformPassword = conformPasswprdTExtField.text, !email.isEmpty, !username.isEmpty, !password.isEmpty, !conformPassword.isEmpty else {
      presentAlert(message: Strings.shared.emptyAlertString)
      return
    }
    guard conformPassword == password else {
      presentAlert(message: Strings.shared.equalsPasswordsString)
      return
    }
    
    loadingView.startAnimating()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
      self?.viewModel?.registration(name: username, email: email, password: password, completion: {
        
        self?.presentAlert(message: Strings.shared.errorAlertString)
        self?.loadingView.stopAnimating()
      })
    }
  }
  
  @objc func keyBoardWillChange(notification: Notification) {
    
//    guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else  { return }
    
    if notification.name == UIResponder.keyboardWillShowNotification {
      
//      view.frame.origin.y = -keyboardRect.height
      view.frame.origin.y = -100
    } else {
      
      view.frame.origin.y = 0
    }
    
  }
  
  private func setupBindings() {
    
    
  }
  
}

extension RegistrationViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    self.view.endEditing(true)
    
    return true
  }
  
  func presentAlert(message: String) {
    
    let alert = AlertController(title: Strings.shared.error, message: message, preferredStyle: .alert)
    present(alert, animated: true)
  }
}
