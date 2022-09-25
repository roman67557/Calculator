//
//  MainModuleCoordinator.swift
//  Calculator
//
//  Created by Роман on 22.09.2022.
//

import UIKit
import RxSwift

protocol MainModuleCoordinatorProtocol {
  
  
}

class MainModuleCoordinator: BaseCoordinator, MainModuleCoordinatorProtocol {
  
  private let bag = DisposeBag()
  
  init(navigationController: UINavigationController) {
    super.init()
    
    print("Main Module Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    let view = MainModuleViewController()
    
    view.viewModel = {
      
      let viewModel = MainViewModel()
      
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
