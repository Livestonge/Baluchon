//
//  CurrencyViewModelTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 28/02/2022.
//

import XCTest
import RxSwift
@testable import Baluchon

class CurrencyViewModelTest: CurrencyAPITest {

  var viewModel: CurrencyViewModel?
  
  override func setUpWithError() throws {
    viewModel = CurrencyViewModel(initialState: .init(),
                                  initialAction: .hasTappedValue(100.0),
                                  service: FixerServiceProviding())
      try super.setUpWithError()
  }

  override func tearDownWithError() throws {
      viewModel = nil
      try super.tearDownWithError()
  }

  func testSwitchCurrency(){
    // when
    let initialState = viewModel?.getCurrentState()
    viewModel?.action = .didSwitchedCurrency(50)
//    then
    let state = viewModel?.getCurrentState()
    XCTAssertNotEqual(initialState?.baseCurrency, state?.baseCurrency)
  }
  
  func testRateForEuro(){
    // when
    viewModel?.action = .hasTappedValue(10)
//    then
    var expectedRate: Double? = nil
    
    if let storedCurrency = getStoredCurrency(){
      expectedRate = storedCurrency.baseRate
    }else{
      expectedRate = mockedCurrency?.baseRate
    }
    let rate = viewModel?.getCurrentState().rate
    XCTAssertEqual(rate, expectedRate)
  }

}
