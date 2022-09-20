//
//  CoordinatorProtocol.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import UIKit

//MARK: - Coordinator

protocol CoordinatorProtocol: AnyObject {
  
  var isCompleted: (() -> ())? { get set }
  var navigationController: UINavigationController { get set }
  var childCoordinators: [CoordinatorProtocol] { get set }
  func start()
  func finish()
}

extension CoordinatorProtocol {
  
  func finish() {
    
    childCoordinators.removeAll()
  }
}

extension CoordinatorProtocol {
  
  func add(childCoordinator: CoordinatorProtocol) {
    
    childCoordinators.append(childCoordinator)
  }
  
  func remove(childCoordinator: CoordinatorProtocol) {
    
    childCoordinators = childCoordinators.filter({ $0 !== childCoordinator })
  }
}

