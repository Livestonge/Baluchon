//
//  ResetButton.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 05/03/2022.
//

import Foundation
import UIKit



extension UIButton{
  
  static var resetButton: UIButton{
    let button = UIButton(type: .close)
    return button
  }
}

extension UIView{
  
  func addCloseButton(button: UIButton){
    
    button.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(button)
    NSLayoutConstraint.activate([
      button.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -10),
      button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
    self.sizeToFit()
  }
}
