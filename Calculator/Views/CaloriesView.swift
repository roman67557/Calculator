//
//  CaloriesView.swift
//  Calculator
//
//  Created by Роман on 29.09.2022.
//

import UIKit

class CaloriesView: UIView {
  
  private let mainLabel = UILabel()
  private let caloriesLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    
    self.backgroundColor = .main
    
    addSubViews()
    setupMainLabel()
    setupCaloriesLabel()
    setupConstraints() 
  }
  
  private func addSubViews() {
    
    [mainLabel, caloriesLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview($0)
    }
  }
  
  private func setupMainLabel() {
    
    mainLabel.font = .systemFont(ofSize: 20)
    mainLabel.text = "Пищевая ценность на 100г:"
    mainLabel.textAlignment = .center
  }
  
  private func setupCaloriesLabel() {
    
    caloriesLabel.font = .systemFont(ofSize: 20)
    caloriesLabel.textAlignment = .center
  }
  
  private func setupConstraints() {
    
    mainLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    mainLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    mainLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    caloriesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 55).isActive = true
    caloriesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    caloriesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    caloriesLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
}

extension CaloriesView {
  
  public func configure(viewModel: DetailedViewModelProtocol) {
    
    caloriesLabel.text = "Энергетическая ценность: \(viewModel.getCalories()) ккал"
  }
}
