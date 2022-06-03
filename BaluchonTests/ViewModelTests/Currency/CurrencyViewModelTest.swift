//
//  CurrencyViewModelTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 28/02/2022.
//

import XCTest
import RxSwift
@testable import Baluchon

class CurrencyViewModelTest: XCTestCase {

  var viewModel: CurrencyManager?
  
  private var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }
  
  lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()
  
  var storedCurrency: CurrencyExchange{
    try! self.decoder.decode(CurrencyExchange.self, from: jsonData!)
  }
  
  override func setUpWithError() throws {
    viewModel = CurrencyManager(initialState: .init(),
                                  initialAction: .hasTappedValue(100.0),
                                  service: MockCurrencyRestApi())
      try super.setUpWithError()
  }

  override func tearDownWithError() throws {
      viewModel = nil
      try super.tearDownWithError()
  }

  func testSwitchCurrency(){
    // when
    let expectation = XCTestExpectation(description: "Switch currency")
    let initialState = viewModel?.getCurrentState()
    var currentState: CurrentBaseState?
    viewModel?.action = .didSwitchedCurrency(50)
    
//    then
    _ = viewModel?.getStateChanges()
                          .subscribe(onNext: { state in
                            currentState = state
                            expectation.fulfill()
                          })
    
    wait(for: [expectation], timeout: 2)
    XCTAssertNotEqual(initialState?.baseCurrency.rawValue, currentState?.baseCurrency.rawValue)
  }
  
  func testRateForEuro(){
    // when
    var currentRate: Double?
    let expectedRate = storedCurrency.baseRate
    let expectation = XCTestExpectation(description: "rate conversion")
    viewModel?.action = .hasTappedValue(10)
//    then
    _ = viewModel?.getStateChanges()
                  .subscribe(onNext: { state in
                    currentRate = state.rate
                    expectation.fulfill()
                  })
    
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(currentRate, expectedRate)
  }

}
