//
//  FoodSelectedTableViewCell.swift
//  Calculator
//
//  Created by Роман on 29.07.2022.
//

import UIKit
import RxSwift

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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: topInsect, left: leftInsect, bottom: bottomInsect, right: rightInsect))
  }
  
  public func configure(with model: FoodSelected) {
    
    if #available(iOS 14.0, *) {
      var content = self.defaultContentConfiguration()
      content.text = model.foodName
      content.secondaryText = "\(model.weight ?? 0)г/\(model.calories ?? 0)ккал"
      content.textProperties.color = .mainReversed ?? UIColor()
      self.contentConfiguration = content
    } else {
      self.textLabel?.text = model.foodName
      self.detailTextLabel?.text = "\(model.weight ?? 0)г/\(model.calories ?? 0)ккал"
    }
    
    self.contentView.layer.cornerRadius = cornerRadius
    self.contentView.layer.borderColor = UIColor.borderColor
    self.contentView.layer.borderWidth = borderWidth
    
    self.backgroundColor = .cellColor
    self.contentView.backgroundColor = .main
  }
  
}
