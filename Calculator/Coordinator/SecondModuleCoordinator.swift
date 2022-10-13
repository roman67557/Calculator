//
//  SecondModuleCoordinator.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import UIKit
import RxSwift

protocol SecondModuleCoordinatorProtocol {
  
  
}

class SecondModuleCoordinator: BaseCoordinator, SecondModuleCoordinatorProtocol {
  
  private let bag = DisposeBag()
  
  init(navigationController: UINavigationController) {
    super.init()
    
    print("Second Module Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    let view = SecondViewController()
    
    view.viewModel = {
      
      let viewModel = SecondViewModel()
    
      
      return viewModel
    }()
    
    navigationController.pushViewController(view, animated: true)
  }
  
  deinit {
    print("Second Coordinator deinit")
  }
    
}
