//
//  EmptyView.swift
//  Calculator
//
//  Created by Роман on 29.07.2022.
//

import UIKit
import Foundation

class EmptyView: UIView {
  
  private let label = UILabel()
//  private let detailedLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    
    addSubViews()
    setupLabel()
//    detailedLabelSetup()
    setupConstraints()
  }
  
  private func addSubViews() {
    
    [label, /*detailedLabel*/].forEach {
      
      $0.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview($0)
    }
  }
  
  private func setupLabel() {
    
    label.font = .systemFont(ofSize: 25)
    label.text = Strings.shared.empty
    label.textAlignment = .center
  }
  
//  private func detailedLabelSetup() {
//
//    detailedLabel.font = .systemFont(ofSize: 15)
//    detailedLabel.text = "Здесь будут отображаться выбранные продукты."
//    detailedLabel.textAlignment = .center
//  }
  
  private func setupConstraints() {
    
    
    label.heightAnchor.constraint(equalToConstant: 50).isActive = true
    label.bottomAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    
//    detailedLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//    detailedLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    detailedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//    detailedLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
  }
  
}
