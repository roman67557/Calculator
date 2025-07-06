//
//  AppCoordinator.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import UIKit
import FirebaseAuth
import RxRelay
import RxSwift

var errorSubject = PublishSubject<Error?>()

protocol AppCoordinatorProtocol: BaseCoordinator {
  
  func goToStart()
  func goToMain()
  
  func alertPresent()
}

class AppCoordinator: BaseCoordinator, AppCoordinatorProtocol {
  private let bag = DisposeBag()
  
  init(navigationController: UINavigationController) {
    super.init()
    
    print("App Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    Auth.auth().addStateDidChangeListener { auth, user in

      if user != nil {
        self.goToMain()
      } else {
        self.goToStart()
      }
    }
    
    alertPresent()
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

extension AppCoordinator {
  
  func alertPresent() {
    errorSubject
      .subscribe(onNext: { [weak self] error in
        let alert = AlertController(title: Strings.shared.error, message: error?.localizedDescription, preferredStyle: .alert)
        
        if self?.navigationController.presentedViewController == nil {
          self?.navigationController.present(alert, animated: true)
        }
        else {
          self?.navigationController.presentedViewController?.present(alert, animated: true)
        }
      })
      .disposed(by: bag)
  }
}
