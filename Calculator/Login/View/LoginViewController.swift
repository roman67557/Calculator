//
//  LoginViewController.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import UIKit

class LoginViewController: UIViewController {
  
  var viewModel: LoginvViewModelPorotcol!
  
  private let loginButton = UIButton()
  private let emailTextField = UITextField()
  private let passwordTextField = UITextField()
  private let conformPasswordTextField = UITextField()
  private let loadingView = UIActivityIndicatorView(style: .large)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  private func setup() {
    
    addSubViews()
    setupColor()
    setupKeyboardSettings()
    setuploginButton()
    setupLoginTextField()
    setupPasswordTextField()
    setupConformPasswordTextField()
    setupConstraints()
  }
  
  private func addSubViews() {
    [loginButton, emailTextField, passwordTextField, conformPasswordTextField, loadingView].forEach {
      
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupColor() {
    self.view.backgroundColor = .main
  }
  
  private func setupKeyboardSettings() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  private func setuploginButton() {
    
    loginButton.setTitle(Strings.shared.loginButtonString, for: .normal)
    loginButton.backgroundColor = .subMain
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.layer.cornerRadius = 8.0
    loginButton.addTarget(self, action: #selector(didLoginButtonTapped(_:)), for: .touchUpInside)
  }
  
  private func setupLoginTextField() {
    
    emailTextField.delegate = self
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
  
  private func setupPasswordTextField() {
    
    passwordTextField.delegate = self
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
    
    conformPasswordTextField.delegate = self
    conformPasswordTextField.placeholder = Strings.shared.conformPasswordPlaceholderString
    conformPasswordTextField.font = .systemFont(ofSize: 15)
    conformPasswordTextField.borderStyle = .roundedRect
    conformPasswordTextField.autocorrectionType = .no
    conformPasswordTextField.keyboardType = .default
    conformPasswordTextField.returnKeyType = .done
    conformPasswordTextField.clearButtonMode = .whileEditing
    conformPasswordTextField.contentVerticalAlignment = .center
    conformPasswordTextField.layer.cornerRadius = 8.0
    conformPasswordTextField.isSecureTextEntry = true
    conformPasswordTextField.autocapitalizationType = .none
  }
  
  private func setupConstraints() {
    
    loginButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    loginButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    loginButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    loginButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    
    emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 2).isActive = true
    emailTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.frame.size.width / 8).isActive = true
    emailTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.frame.size.width / 8).isActive = true
    emailTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
    passwordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.frame.size.width / 8).isActive = true
    passwordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.frame.size.width / 8).isActive = true
    passwordTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
    conformPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
    conformPasswordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.frame.size.width / 8).isActive = true
    conformPasswordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.frame.size.width / 8).isActive = true
    conformPasswordTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    
    loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
  
  private func setupAlert(message: String) {
    
    let alert = AlertController(title: Strings.shared.error, message: message, preferredStyle: .alert)
    present(alert, animated: true)
  }
  
  @objc private func didLoginButtonTapped(_ sender: Any) {
    
    self.view.endEditing(true)
    
    guard let email = emailTextField.text, let password = passwordTextField.text, let conformPassword = conformPasswordTextField.text, !email.isEmpty, !password.isEmpty, !conformPassword.isEmpty else {
      setupAlert(message: Strings.shared.emptyAlertString)
      return
    }
    guard conformPassword == password else {
      setupAlert(message: Strings.shared.equalsPasswordsString)
      return
    }
    
    loadingView.startAnimating()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
      self?.viewModel?.signIn(email: email, password: password, completion: {
        
        self?.setupAlert(message: Strings.shared.errorAlertString)
        self?.loadingView.stopAnimating()
      })
    }
  }
  
  @objc func keyBoardWillChange(notification: Notification) {
    
//    guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else  { return }
    
    if notification.name == UIResponder.keyboardWillShowNotification {
      
//      view.frame.origin.y = -keyboardRect.height
      view.frame.origin.y = -view.frame.size.height / 4
    } else {
      
      view.frame.origin.y = 0
    }
    
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if emailTextField.isFirstResponder {
      passwordTextField.becomeFirstResponder()
    } else if passwordTextField.isFirstResponder {
      conformPasswordTextField.becomeFirstResponder()
    } else {
      self.view.endEditing(true)
    }
    
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
}
