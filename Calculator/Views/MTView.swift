//
//  MTView.swift
//  Calculator
//
//  Created by Роман on 24.07.2022.
//

import UIKit

class MTView: UIView {
  
  private let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
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
    label.text = Strings.shared.nothingHaveFound
    label.textAlignment = .center
  }
  
  private func setupConstraints() {
    
    label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
  }
  
}
