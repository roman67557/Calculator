//
//  AppCoordinator.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import UIKit
import FirebaseAuth

protocol AppCoordinatorProtocol: BaseCoordinator {
  
  func goToStart()
  func goToMain()
}

class AppCoordinator: BaseCoordinator, AppCoordinatorProtocol {
  
  init(navigationController: UINavigationController) {
    super.init()
    
    print("App Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    print("App Coordinator init")
    
    Auth.auth().addStateDidChangeListener { auth, user in

      if user != nil {
        self.goToMain()
      } else {
        self.goToStart()
      }
    }
  }
  
  func goToStart() {
    
    let startCoordinator = StartCoordinator(navigationController: navigationController)
    self.add(childCoordinator: startCoordinator)

    
    startCoordinator.isCompleted = { [weak self, weak startCoordinator] in
      
      guard let coordinator = startCoordinator else { return }
      self?.remove(childCoordinator: coordinator)
    }
    
    startCoordinator.start()
  }

  deinit {
    print("App Coordinator deinit")
  }
  
  func goToMain() {
    let tabCoordinator = TabCoordinator(navigationController: navigationController)
    self.add(childCoordinator: tabCoordinator)
    navigationController.setNavigationBarHidden(true, animated: false)
    
    tabCoordinator.isCompleted = { [weak self, weak tabCoordinator] in
      
      guard let coordinator = tabCoordinator else { return }
      self?.remove(childCoordinator: coordinator)
    }
    
    tabCoordinator.start()
  }
  
}
