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
      
      //      viewModel.isRegistered
      //        .subscribe(onNext: { [weak self] bool in
      //          if bool == true {
      //
      //          }
      //        })
      //        .disposed(by: bag)
      
      return viewModel
    }()
    
    navigationController.present(view, animated: true)
  }
    
}
