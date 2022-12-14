//
//  TabCoordinator.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import UIKit

protocol TabCoordinatorProtocol {
  
  var tabBarController: UITabBarController { get set }
}

class TabCoordinator: BaseCoordinator, TabCoordinatorProtocol {
  
  var tabBarController: UITabBarController
  
  init(navigationController: UINavigationController) {
    self.tabBarController = .init()
    
    super.init()
    
    print("Tab Coordinator init")
    self.navigationController = navigationController
  }
  
  override func start() {
    
    let pages: [TabBarPage] = [.main, .second, .user]
      .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
    
    let controllers: [UINavigationController] = pages.map({ getTabController($0) })
    
    prepareTabBarController(withTabControllers: controllers)
    
    setupStatusBarColor()
  }
  
  private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
    tabBarController.setViewControllers(tabControllers, animated: true)
    tabBarController.selectedIndex = TabBarPage.main.pageOrderNumber()
    tabBarController.tabBar.isTranslucent = false
    tabBarController.tabBar.backgroundColor = .cellColor
    tabBarController.tabBar.barTintColor = .cellColor
    tabBarController.tabBar.tintColor = .mainReversed
    
    navigationController.viewControllers = [tabBarController]
  }
  
  private func getTabController(_ page: TabBarPage) -> UINavigationController {
    
    let navigationController: UINavigationController = {
      let navController = UINavigationController()
      let navBar = navController.navigationBar
      
      let appearance = UINavigationBarAppearance()
      
      appearance.backgroundColor = .cellColor
    
      navBar.backgroundColor = .cellColor
      navBar.tintColor = .subMain
      
      navBar.layer.borderColor = UIColor.borderColor
      
      navBar.scrollEdgeAppearance = appearance
      navBar.standardAppearance = appearance
      navBar.compactAppearance = appearance
      if #available(iOS 15.0, *) {
        navBar.compactScrollEdgeAppearance = appearance
      } else {
        // Fallback on earlier versions
      }
      
      return navController
    }()
    
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
  
  private func setupStatusBarColor() {
    
    if #available(iOS 13.0, *) {
      
      let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
      statusBar.backgroundColor = .cellColor
      
      UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)
      
    } else {
      
      let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
      statusBar?.backgroundColor = .cellColor
      
    }
  }
  
}
