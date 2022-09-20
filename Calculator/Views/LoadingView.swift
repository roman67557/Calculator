//
//  LoadingView.swift
//  Calculator
//
//  Created by Роман on 28.07.2022.
//

import UIKit

class LoadingView: UIImageView {
  
  var imageForSpinning: UIImage
  
  init(imageForSpinning: UIImage) {
    
    self.imageForSpinning = imageForSpinning
    
    super.init(image: imageForSpinning)

    self.image = imageForSpinning
    self.contentMode = .scaleAspectFit
    rotateView(targetView: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func rotateView(targetView: UIView, duration: Double = 0.5) {
      UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
          targetView.transform = targetView.transform.rotated(by: .pi)
      }) { finished in
          self.rotateView(targetView: targetView, duration: duration)
      }
  }

}
