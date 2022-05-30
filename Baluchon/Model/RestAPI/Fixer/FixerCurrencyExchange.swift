//
//  FixerCurrencyExchange.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 22/05/2022.
//

import Foundation

struct FixerCurrencyExchange {
  
  let date: Date
  var base: Currency
  var rates: [Currency: Double] = [:]
  
  func mapToCurrencyExchange() -> CurrencyExchange{
           CurrencyExchange(date: date,
                            base: base,
                            rates: rates)
  }
}
