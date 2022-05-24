//
//  Protocol_conformance.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 24/05/2022.
//

import Foundation

extension ViewController: ConvertedValueDelegate {
  
  func didReceiveConverted(value: Double) {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    let number = NSNumber(value: value)
    let text = formatter.string(from: number)!
    
    subscribeToMainThread { [weak self] in
      self?.convertedCurrencyLabel.text = text
    }
   
  }
  
  func didFailWith(_ error: BaluchonError) {
    
    subscribeToMainThread { [weak self] in
      self?.presentAlertFor(error)
    }
  }
  
  private func presentAlertFor(_ error: BaluchonError){
    let alertVC = BaluchonAlert(error: error).controller
    present(alertVC, animated: true)
  }
  
}
