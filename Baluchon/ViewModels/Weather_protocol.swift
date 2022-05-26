//
//  Weather_protocol.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 24/05/2022.
//

import Foundation

protocol Failable{
  func didFailWith(_ error: BaluchonError)
}
protocol WeatherDataDelegate: AnyObject, Failable {
  func didReceive(_ weather: Weather)
}
