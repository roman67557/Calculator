//
//  FoodDetailedCoordinator.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import UIKit
import RxSwift

protocol FoodDetailedCoordinatorProtocol {
  
}

class FoodDetailedCoordinator: BaseCoordinator, FoodDetailedCoordinatorProtocol {
  
  private let bag = DisposeBag()
  private var model: Branded
  
  init(navigationController: UINavigationController, model: Branded) {
    self.model = model
    
    super.init()
    
    print("Detailed Module Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    let view = DetailedViewController()
    
    view.viewModel = {
      
      let viewModel = DetailedViewModel(model: model)
      
      viewModel.closeRelay
        .subscribe(onNext: { [weak self] bool in
          if bool == true {
            self?.closeDetailedModule()
          }
        })
        .disposed(by: bag)
      
      return viewModel
    }()
    
    navigationController.present(view, animated: true)
  }
  
  func closeDetailedModule() {
    
    navigationController.dismiss(animated: true)
  }
  
}
