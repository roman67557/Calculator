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
      let networkService = NetworkService()
      let viewModel = MainViewModel(networkService: networkService)
      
      viewModel.goSubject
        .map { [weak self] branded in
          self?.goToDetailed(model: branded)
        }
        .subscribe()
        .disposed(by: bag)
      
      return viewModel
    }()
    
    navigationController.pushViewController(view, animated: true)
  }
  
  private func goToDetailed(model: Branded) {
    
    let detailedCoordinator = FoodDetailedCoordinator(navigationController: navigationController, model: model)
    self.add(childCoordinator: detailedCoordinator)
    
    detailedCoordinator.isCompleted = { [weak self, weak detailedCoordinator] in
      
      guard let coordinator = detailedCoordinator else { return }
      self?.remove(childCoordinator: coordinator)
    }
    
    detailedCoordinator.start()
  }
    
}
