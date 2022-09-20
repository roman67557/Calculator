//
//  UserCoordinator.swift
//  Calculator
//
//  Created by Роман on 07.08.2022.
//

import RxSwift

protocol UserCoordinatorProtocol {
  
  
}

class UserCoordinator: BaseCoordinator, UserCoordinatorProtocol {
  
  private let bag = DisposeBag()
  
  init(navigationController: UINavigationController) {
    super.init()
    
    self.navigationController =  navigationController
  }
  
  override func start() {
    
    let view = UserViewController()
    
    view.viewModel = {
      
      let viewModel = UserViewModel()
      
      return viewModel
    }()
    
    navigationController.pushViewController(view, animated: false)
  }
}
