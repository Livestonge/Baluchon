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
}

extension FixerCurrencyExchange: Codable {
  
  enum CodingKeys: CodingKey{
    case date, base, rates
  }
  
  init(from decoder: Decoder) throws {
    do{
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.date = try container.decode(Date.self, forKey: .date)
      self.base = try container.decode(Currency.self, forKey: .base)
      let dict = try container.decode([String: Double].self, forKey: .rates)
      for (key, value) in dict {
        if let currency = Currency(rawValue: key){
          self.rates[currency] = value
        }
      }
    } catch {
      throw BaluchonError.decodingError
    }
    
  }
  
  func encode(to encoder: Encoder) throws {
   var container = encoder.container(keyedBy: CodingKeys.self)
    try? container.encode(date, forKey: .date)
    try? container.encode(base, forKey: .base)
    var dict: [String: Double] = [:]
    for (key, value) in rates {
      dict[key.rawValue] = value
      }
    try? container.encode(dict, forKey: .rates)
  }
}
