//
//  ExitTableViewCell.swift
//  Calculator
//
//  Created by Роман on 07.08.2022.
//

import UIKit

class ExitTableViewCell: UITableViewCell {
  
  static let identifier = "ExitTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    
    self.textLabel?.text = Strings.shared.exit
    self.textLabel?.textColor = .red
    self.textLabel?.textAlignment = .center
    
    setupConstraints()
  }
  
  func setupConstraints() {
    
    self.textLabel?.translatesAutoresizingMaskIntoConstraints = false
    
    textLabel?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    textLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    textLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    textLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
