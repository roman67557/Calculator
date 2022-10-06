//
//  MTView.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import UIKit

class EmptyView: UIView {
  
  private let label = UILabel()
  var text: String
  
  init(text: String) {
    self.text = text
    
    super.init(frame: CGRect())
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    
    addSubViews()
    labelSetup()
    setupConstraints()
  }
  
  private func addSubViews() {
    
    [label].forEach {
      
      $0.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview($0)
    }
  }
  
  private func labelSetup() {
    
    label.font = label.font.withSize(25)
    label.text = text
    label.textAlignment = .center
  }
  
  private func setupConstraints() {
    
    label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
  }
  
}
