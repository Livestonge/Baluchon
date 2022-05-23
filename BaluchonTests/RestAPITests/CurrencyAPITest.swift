//
//  CurrencyAPITest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 28/02/2022.
//

import XCTest
import Foundation
import RxSwift
@testable import Baluchon

class CurrencyAPITest: XCTestCase {
  
  var service: FixerServiceProviding?
  let bag = DisposeBag()
  
  private var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }
  
  lazy var components: URLComponents = {
    let todayCalenderString: String = dateFormatter.string(from: Date() - 2)
    var components = URLComponents()
    components.scheme = "http"
    components.host = "data.fixer.io"
    components.path = "/api/\(todayCalenderString)"
    
    components.queryItems = [
      URLQueryItem(name: "access_key", value: fixer_Conversion_Api_Key),
      URLQueryItem(name: "base", value: "EUR"),
      URLQueryItem(name: "symbols", value: Currency.USD.rawValue)
    ]
    return components
  }()
  
  lazy private var fileStorage: URL = {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return path.appendingPathComponent("currencyStorage")
  }()
  
  lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()
  
  lazy var mockedCurrency: CurrencyExchange? = {
    return try? decoder.decode(CurrencyExchange.self, from: jsonData!)
  }()

    override func setUpWithError() throws {
      service = FixerServiceProviding()
      try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        service = nil
      try super.tearDownWithError()
    }
  
  func testURL(){
    XCTAssertEqual(self.components.url, service?.components.url)
  }
  
  func getStoredCurrency() -> CurrencyExchange? {
    guard let storedData = try? Data(contentsOf: self.fileStorage),
        let storedCurrency = try? decoder.decode(CurrencyStorage.self, from: storedData),
          storedCurrency.hasExpired == false else
          { return nil }
    return storedCurrency.currencyExchange
  }
  
  func testgetCurrency() throws{
    let expectation = self.expectation(description: "CurrencyExchange")
    var expectedCurrency: CurrencyExchange? = nil
    var receivedCurrency: CurrencyExchange? = nil
    
    if let storedCurrency = getStoredCurrency() {
      expectedCurrency = storedCurrency
    }else {
      expectedCurrency = self.mockedCurrency!
    }
    
    service?.getCurrencyExchange()
      .subscribe(onNext: { currency in
        receivedCurrency = currency
        expectation.fulfill()
      })
      .disposed(by: bag)
    
    waitForExpectations(timeout: 2, handler: nil)
    XCTAssertEqual(receivedCurrency, expectedCurrency)
    
  }
  
  func testGettingSavedCurrency() throws {
    let expectedCurrency = getStoredCurrency()
    let currency = service?.getStoredCurrencyExchange()
    XCTAssertEqual(expectedCurrency, currency)
  }

}
