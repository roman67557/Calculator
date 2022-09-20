//
//  TotalCaloriesView.swift
//  Calculator
//
//  Created by Роман on 01.08.2022.
//

import UIKit

class TotalCaloriesView: UIView {
  
  private let totalLabel = UILabel()
  let caloriesLabel = UILabel()
  var caloriesSum: Int?

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    
    addSubViews()
    setupTotalLabel()
    setupCaloriesLabel()
    setupConstraints()
  }
  
  private func addSubViews() {
    
    [totalLabel, caloriesLabel].forEach {
      
      $0.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview($0)
    }
  }
  
  private func setupTotalLabel() {
    
    totalLabel.font = .systemFont(ofSize: 20)
    totalLabel.text = Strings.shared.caloriesSum
    totalLabel.textAlignment = .left
  }
  
  private func setupCaloriesLabel() {
    
    caloriesLabel.font = .systemFont(ofSize: 20)
//    caloriesLabel.text = "\(String(describing: caloriesSum ?? 0))"
    caloriesLabel.textAlignment = .right
  }
  
  private func setupConstraints() {
    
    totalLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    totalLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    totalLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    totalLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    
    caloriesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    caloriesLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    caloriesLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    caloriesLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
  
}
