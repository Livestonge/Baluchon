//
//  CurrencyExchange.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 23/01/2022.
//

import Foundation

struct CurrencyExchange {
  
  let date: Date
  var base: Currency
  var rates: [Currency: Double] = [:]
  
  var baseRate: Double {
    guard let eurUsdRate = rates[Currency.USD], eurUsdRate > 0.0 else {return 0.0}
    return base == .EUR ? eurUsdRate : 1 / eurUsdRate
  }
}


