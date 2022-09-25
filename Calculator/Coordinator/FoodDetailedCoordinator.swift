//
//  FoodDetailedCoordinator.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import RxSwift

protocol FoodDetailedCoordinatorProtocol {
  
}

class FoodDetailedCoordinator: BaseCoordinator, FoodDetailedCoordinatorProtocol {
  
  private let bag = DisposeBag()
  
  init(navigationController: UINavigationController) {
    super.init()
    
    print("Main Module Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    let view = DetailedViewController()
    
    view.viewModel = {
      
      let viewModel = DetailedViewModel()
      
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
