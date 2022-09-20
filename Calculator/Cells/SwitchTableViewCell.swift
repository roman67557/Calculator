//
//  SwitchTableViewCell.swift
//  Calculator
//
//  Created by Роман on 07.08.2022.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
  
  static let identifier = "SwitchTableViewCell"

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    
    self.accessoryView = UISwitch()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
