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
      
//      viewModel.isRegistered
//        .subscribe(onNext: { [weak self] bool in
//          if bool == true {
//            
//          }
//        })
//        .disposed(by: bag)
      
      return viewModel
    }()
    
    navigationController.pushViewController(view, animated: true)
  }
  
  func signIn() {
    
    
  }
}
