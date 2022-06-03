//
//  URL_extension.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 01/06/2022.
//

import Foundation

extension URL{
  static var currencyStorage: URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return path.appendingPathComponent("currencyStorage")
  }
}
