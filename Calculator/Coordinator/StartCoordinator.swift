//
//  StartCoordinator.swift
//  Calculator
//
//  Created by Роман on 27.07.2022.
//

import UIKit
import RxSwift

protocol StartCoordinatorProtocol {
  
  func goToLogin()
  func goToRegistration()
}

class StartCoordinator: BaseCoordinator, StartCoordinatorProtocol {
  
  private let bag = DisposeBag()
  
  required init(navigationController: UINavigationController) {
    super.init()
    
    print("Start Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    let view = StartViewController()
    
    view.viewModel = {
      let viewModel = StartViewModel()
        
      viewModel.registrationButtonRelay
        .subscribe({ _ in self.goToRegistration() })
        .disposed(by: bag)
      
      viewModel.loginButtonRelay
        .subscribe({ _ in self.goToLogin() })
        .disposed(by: bag)
      
      return viewModel
    }()
    
    navigationController.pushViewController(view, animated: false)
    setupStatusBarColor()
  }
  
  deinit {
    print("Start Coordinator deinit")
  }
}

extension StartCoordinator {
  
  func goToLogin() {
    
    let loginCoordinator = LoginCoordinator(navigationController: navigationController)
    self.add(childCoordinator: loginCoordinator)
    
    loginCoordinator.isCompleted = { [weak self, weak loginCoordinator] in
      
      guard let coordinator = loginCoordinator else { return }
      self?.remove(childCoordinator: coordinator)
    }
    
    loginCoordinator.start()
  }
  
  func goToRegistration() {
    
    let registrationCoordinator = RegistrationCoordinator(navigationController: navigationController)
    self.add(childCoordinator: registrationCoordinator)
    
    registrationCoordinator.isCompleted = { [weak self, weak registrationCoordinator] in
      
      guard let coordinator = registrationCoordinator else { return }
      self?.remove(childCoordinator: coordinator)
    }
    
    registrationCoordinator.start()
  }
  
  private func setupStatusBarColor() {
    
    if #available(iOS 13.0, *) {
      
      let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
      statusBar.backgroundColor = .clear
      
      UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)
      
    } else {
      
      let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
      statusBar?.backgroundColor = .clear
    }
  }
  
}
