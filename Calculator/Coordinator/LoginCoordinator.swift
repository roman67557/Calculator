//
//  LoginCoordinator.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import Foundation
import RxSwift

protocol LoginCoordinatorProtocol {
  
  func signIn()
}

class LoginCoordinator: BaseCoordinator, LoginCoordinatorProtocol {
  
  private let bag = DisposeBag()
  
  init(navigationController: UINavigationController) {
    super.init()
    
    print("Login Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    let view = LoginViewController()
    
    view.viewModel = {
      
      let viewModel = LoginViewModel()
      
      viewModel.isSigned
        .subscribe(onNext: { [weak self] bool in
          if bool == true {
            self?.signIn()
          }
        })
        .disposed(by: bag)
      
      return viewModel
    }()
    
    navigationController.pushViewController(view, animated: true)
  }
  
  func signIn() {
    
    let tabCoordinator = TabCoordinator(navigationController: navigationController)
    self.add(childCoordinator: tabCoordinator)
    
    tabCoordinator.isCompleted = { [weak self, weak tabCoordinator] in
      
      guard let coordinator = tabCoordinator else { return }
      self?.remove(childCoordinator: coordinator)
    }
    
    tabCoordinator.start()
  }
}
