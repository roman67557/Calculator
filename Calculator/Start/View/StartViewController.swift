//
//  StartViewController.swift
//  Calculator
//
//  Created by Роман on 26.07.2022.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {
  
  var viewModel: StartViewModelProtocol?
  
  private let buttons = (loginButton: UIButton(), registrationButton: UIButton())
  private let imageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
}

extension StartViewController {
  
  private func setup() {
    
    self.view.backgroundColor = .main
    addSubViews()
    setupImageView()
    setupLoginButton()
    setupRegistrationButton()
    setupConstraints()
  }
  
  private func addSubViews() {
    
    [buttons.loginButton, buttons.registrationButton, imageView].forEach {
      
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupImageView() {
    
    guard let image = UIImage.ivanFirst else { return }
    imageView.backgroundColor = .main
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
  }
  
  private func setupLoginButton() {
    
    buttons.loginButton.setTitle(Strings.shared.loginButtonString, for: .normal)
    buttons.loginButton.backgroundColor = .subMain
    buttons.loginButton.setTitleColor(.white, for: .normal)
    buttons.loginButton.layer.cornerRadius = 8.0
    buttons.loginButton.addTarget(self, action: #selector(loginButtonDidTapped(_:)), for: .touchUpInside)
  }
  
  private func setupRegistrationButton() {
    
    buttons.registrationButton.setTitle(Strings.shared.registrtionBttonString, for: .normal)
    buttons.registrationButton.backgroundColor = .clear
    buttons.registrationButton.setTitleColor(.subMain, for: .normal)
    buttons.registrationButton.layer.cornerRadius = 8.0
    buttons.registrationButton.addTarget(self, action: #selector(registrationButtonDidTapped(_:)), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    
    imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50).isActive = true
    imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: buttons.loginButton.topAnchor, constant: -50).isActive = true
    
    buttons.registrationButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    buttons.registrationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    buttons.registrationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    buttons.registrationButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    
    buttons.loginButton.bottomAnchor.constraint(equalTo: buttons.registrationButton.topAnchor, constant: 5).isActive = true
    buttons.loginButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
    buttons.loginButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    buttons.loginButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
  }
  
  @objc private func loginButtonDidTapped(_ sender: Any) {
    
    viewModel?.loginButtonRelay.accept(self.buttons.loginButton.rx.tap)
  }
  
  @objc private func registrationButtonDidTapped(_ sender: Any) {
    
    viewModel?.registrationButtonRelay.accept(self.buttons.registrationButton.rx.tap)
  }

}
