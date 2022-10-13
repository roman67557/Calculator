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
    
    
    if #available(iOS 14.0, *) {
      self.backgroundConfiguration?.backgroundColor = .main
    } else {
      self.textLabel?.backgroundColor = .main
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: topInsect, left: leftInsect, bottom: bottomInsect, right: rightInsect))
  }
  
  public func configure(with model: Branded) {
    
    
    if #available(iOS 14.0, *) {
      var content = self.defaultContentConfiguration()
      content.text = model.foodName
      content.textProperties.color = .mainReversed ?? UIColor()
      self.contentConfiguration = content
    }  else {
      self.textLabel?.text = model.foodName
    }
    
    self.contentView.layer.cornerRadius = cornerRadius
    self.contentView.layer.borderColor = UIColor.borderColor
    self.contentView.layer.borderWidth = borderWidth
    
    self.accessoryType = .none
    self.contentView.backgroundColor = .main
    self.backgroundColor = .cellColor
  }
  
}
