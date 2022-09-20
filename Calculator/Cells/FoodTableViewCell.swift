//
//  FoodTableViewCell.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
  
  static let identifier = "FoodTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    self.accessoryType = .disclosureIndicator
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
