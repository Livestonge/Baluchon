//
//  Storage.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 01/06/2022.
//

import Foundation


struct CurrencyStorage: Codable{
 let date: Date
 var currencyExchange: CurrencyExchange
 
 var hasExpired: Bool{
  return Date() > (date + 3600 * 24 * 3)
 }
}
