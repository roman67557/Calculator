//
//  RegistrationCoordinator.swift
//  Calculator
//
//  Created by Роман on 27.07.2022.
//

import UIKit
import RxSwift

protocol RegistrationCoordinatorProtocol {
  
  func registrationComplete()
}

class RegistrationCoordinator: BaseCoordinator, RegistrationCoordinatorProtocol {
   
  private let bag = DisposeBag()
  
  init(navigationController: UINavigationController) {
    super.init()
    
    print("Registration Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    let view = RegistrationViewController()
    
    view.viewModel = {
      
      let viewModel = RegistrationViewModel()
      
      viewModel.isRegistered
        .subscribe(onNext: { [weak self] bool in
          if bool == true {
            self?.registrationComplete()
          }
        })
        .disposed(by: bag)
      
      return viewModel
    }()
    
    navigationController.present(view, animated: true)
  }
  
  
  
  func registrationComplete() {
    
    navigationController.dismiss(animated: true)
  }
}
