//
//  Currency_protocol.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 24/05/2022.
//

import Foundation

protocol ConvertedValueDelegate: AnyObject {
  func didReceiveConverted(value: Double)
  func didFailWith(_ error: BaluchonError)
}
