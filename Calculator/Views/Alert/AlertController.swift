//
//  AlertController.swift
//  Calculator
//
//  Created by Роман on 09.08.2022.
//

import UIKit

class AlertController: UIAlertController {
  
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
  
  private func setup() {
    
    let action = UIAlertAction(title: Strings.shared.ok, style: .default) { [weak self] action in
      self?.dismiss(animated: true)
    }
    
    self.addAction(action)
  }

}
