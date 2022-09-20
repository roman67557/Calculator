//
//  CoordinatorFinishDelegate.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

//MARK: - Coordinator Output

protocol CoordinatorFinishDelegate: AnyObject {
  
  func coordinatorDidFinish(childCoordinator: CoordinatorProtocol)
}
