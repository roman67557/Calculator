//
//  BaseCoordinator.swift
//  Calculator
//
//  Created by Роман on 28.07.2022.
//

import UIKit

class BaseCoordinator: CoordinatorProtocol {
  
  var isCompleted: (() -> ())? = nil
  var navigationController: UINavigationController = UINavigationController()
  var childCoordinators: [CoordinatorProtocol] = []
  
  func start() {
    print("override this func")
  }
 
  
}
