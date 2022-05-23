//
//  ErrorHandler.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 26/02/2022.
//

import Foundation
import UIKit

struct BaluchonAlert {
  
  private let error: BaluchonError
  let controller: UIAlertController
  
  init(error: BaluchonError){
    self.error = error
    self.controller = UIAlertController(title: error.rawValue,
                                       message: error.description,
                                       preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default)
    controller.addAction(action)
  }
}
