//
//  CurrencyBaseState.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 31/01/2022.
//

import Foundation
import RxSwift
import RxRelay

struct CurrentBaseState {
  
  var convertedValue = 0.0
  var baseCurrency = Currency.EUR
  var rate = 0.0
  var error: BaluchonError? = nil
}


enum CurrencyBaseStateAction{
  case hasTappedValue(Double)
  case didSwitchedCurrency(Double)
}
