//
//  CurrencyViewModelMock.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 06/03/2022.
//

import Foundation
import RxSwift
@testable import Baluchon

class CurrencyMock: CurrencyManager{
  
  class MockService: CurrencyServiceProvider{
    func getCurrencyExchange() -> Observable<CurrencyExchange> {
      let rates: [Currency: Double] = [ .USD : 1.5]
      let obj = CurrencyExchange(date: Date(),
                                 base: .EUR,
                                 rates: rates)
      return .just(obj)
    }
  }
  
  init(){
    let initialCase = CurrentBaseState(convertedValue: 0,
                                       baseCurrency: .EUR,
                                       rate: 2.0,
                                       error: nil)
    super.init(initialState: initialCase,
               initialAction: .hasTappedValue(100),
               service: MockService())
  }
}
