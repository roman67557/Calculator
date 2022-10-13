//
//  TabCoordinatorHelper.swift
//  Calculator
//
//  Created by Роман on 25.09.2022.
//

import UIKit

enum TabBarPage {
  case main
  case second
  case user
  
  init?(index: Int) {
    switch index {
    case 0:
      self = .main
    case 1:
      self = .second
    case 2:
      self = .user
    default:
      return nil
    }
  }
  
  func pageTitleValue() -> String {
    switch self {
    case .main:
      return "Поиск"
    case .second:
      return "Избранное"
    case .user:
      return "Пользователь"
    }
  }
  
  func pageOrderNumber() -> Int {
    switch self {
    case .main:
      return 0
    case .second:
      return 1
    case .user:
      return 2
    }
  }
  
  func pageIconValue() -> UIImage {
    
    switch self {
    case .main:
      return UIImage.searchFood ?? UIImage()
    case .second:
      return UIImage.selectedFood ?? UIImage()
    case .user:
      return UIImage.user ?? UIImage()
    }
  }
  
  func pageIconSelectedValue() -> UIImage {
    
    switch self {
    case .main:
      return UIImage.searchFoodTapped ?? UIImage()
    case .second:
      return UIImage.selectedFoodTapped ?? UIImage()
    case .user:
      return UIImage.userTapped ?? UIImage()
    }
  }
  
}
