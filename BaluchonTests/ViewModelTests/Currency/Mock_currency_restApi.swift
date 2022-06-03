//
//  Mock_currency_restApi.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 03/06/2022.
//

import Foundation
import RxSwift
@testable import Baluchon

class MockCurrencyRestApi: FixerServiceProviding {
  
  override func getCurrencyExchange() -> Observable<CurrencyExchange> {
    let currencyExchange = try? decoder.decode(CurrencyExchange.self, from: jsonData!)
    return .just(currencyExchange!)
  }
  
}
