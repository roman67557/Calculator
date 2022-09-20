//
//  FoodSelectedTableViewCell.swift
//  Calculator
//
//  Created by Роман on 29.07.2022.
//

import UIKit

class FoodSelectedTableViewCell: UITableViewCell {
  
  static let identifier = "FoodSelectedTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    
    self.accessoryType = .none
    self.selectionStyle = .none
    
    self.textLabel?.lineBreakMode = .byClipping
    self.textLabel?.numberOfLines = 0
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
