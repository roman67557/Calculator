//
//  TabCoordinator.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import UIKit

protocol TabCoordinatorProtocol {
  
  var tabBarController: UITabBarController { get set }
  
//  func selectPage(_ page: TabBarPage)
//  func setSelectedIndex(_ index: Int)
//  func currentPage() -> TabBarPage?
}

class TabCoordinator: BaseCoordinator, TabCoordinatorProtocol {
  
  var tabBarController = UITabBarController()
  
  init(navigationController: UINavigationController) {
    super.init()
    
    print("Tab Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    let pages: [TabBarPage] = [.main, .second, .user]
      .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
    
    let controllers: [UINavigationController] = pages.map({ getTabController($0) })
    
    prepareTabBarController(withTabControllers: controllers)
  }
  
  private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
    tabBarController.setViewControllers(tabControllers, animated: true)
    tabBarController.selectedIndex = TabBarPage.main.pageOrderNumber()
    tabBarController.tabBar.isTranslucent = false
    
    navigationController.viewControllers = [tabBarController]
  }
  
  private func getTabController(_ page: TabBarPage) -> UINavigationController {
    
    let navigationController = UINavigationController()
    navigationController.setNavigationBarHidden(false, animated: false)
    
    navigationController.tabBarItem = UITabBarItem(title: page.pageTitleValue(), image: page.pageIconValue(), selectedImage: page.pageIconSelectedValue())
    
    switch page {
    case .main:
      let mainCoordinator = MainModuleCoordinator(navigationController: navigationController)
      self.add(childCoordinator: mainCoordinator)
      
      mainCoordinator.isCompleted = { [weak self, weak mainCoordinator] in
        
        guard let coordinator = mainCoordinator else { return }
        self?.remove(childCoordinator: coordinator)
      }
      mainCoordinator.start()
    
    case .second:
      let secondCoordinator = SecondModuleCoordinator(navigationController: navigationController)
      self.add(childCoordinator: secondCoordinator)
      
      secondCoordinator.isCompleted = { [weak self, weak secondCoordinator] in
        
        guard let coordinator = secondCoordinator else { return }
        self?.remove(childCoordinator: coordinator)
      }
      secondCoordinator.start()
      
    case .user:
      let userCoordinator = UserCoordinator(navigationController: navigationController)
      self.add(childCoordinator: userCoordinator)
      
      userCoordinator.isCompleted = { [weak self, weak userCoordinator] in
        
        guard let coordinator = userCoordinator else { return }
        self?.remove(childCoordinator: coordinator)
      }
      userCoordinator.start()
    }
    
    return navigationController
  }
  
  func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }
  
  func selectPage(_ page: TabBarPage) {
    tabBarController.selectedIndex = page.pageOrderNumber()
    }
  
  func selectedIndex(_ index: Int) {
    guard let page = TabBarPage.init(index: index) else { return }
    
    tabBarController.selectedIndex = page.pageOrderNumber()
  }
  
}
