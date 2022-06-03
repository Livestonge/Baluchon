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
  
  var service: FixerServiceProviding!
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
  
  private var fileStorage: URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return path.appendingPathComponent("testCurrencyStorage")
  }
  
  lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()
  
  lazy var mockedCurrency: CurrencyExchange? = {
    return try? decoder.decode(CurrencyExchange.self, from: jsonData!)
  }()

    override func setUp() {
      super.setUp()
      UrlSessionProxy.reset()
      let configuration = URLSessionConfiguration.ephemeral
      configuration.protocolClasses = [UrlSessionProxy.self]
      let session = URLSession(configuration: configuration)
      let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let testUrl = path.appendingPathComponent("testCurrencyStorage")
      service = FixerServiceProviding(session: session, storage: testUrl)
    }

    override func tearDown(){
      super.tearDown()
      service.session.configuration.protocolClasses = nil
      service = nil
      deleteStoredCurrency()
    }
  
  func testURL(){
    XCTAssertEqual(self.components.url, service?.components.url)
  }
  
  private func deleteStoredCurrency(){
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let file: URL = path.appendingPathComponent("testCurrencyStorage")
    do{
      try Data().write(to: file, options: .atomic)
    }catch{
      print(error.localizedDescription)
      
    }
    
    
  }
  
  func getStoredCurrency() -> CurrencyExchange? {
    deleteStoredCurrency()
    
    let currencyStorage = CurrencyStorage(date: .now, currencyExchange: mockedCurrency!)
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
    let data = try? encoder.encode(currencyStorage)
    try? data?.write(to: self.fileStorage, options: .atomic)
    
    guard let storedData = try? Data(contentsOf: self.fileStorage),
        let storedCurrency = try? decoder.decode(CurrencyStorage.self, from: storedData),
          storedCurrency.hasExpired == false
     else { return nil }
    
    return storedCurrency.currencyExchange
  }
  
  func testgetCurrency() {
    let expectation = XCTestExpectation(description: "CurrencyExchange")
    var receivedCurrency: CurrencyExchange?
    let response = HTTPURLResponse(url: self.components.url!,
                                   statusCode: 200,
                                   httpVersion: nil,
                                   headerFields: ["Content-Type": "application/json"])!
    
    UrlSessionProxy.requestHandler = { [response] request throws -> (Data, HTTPURLResponse) in
      return (jsonData!, response)
    }
     _ = self.service.getCurrencyExchange()
                                     .subscribe(onNext: { currency in
                                       receivedCurrency = currency
                                       expectation.fulfill()
                                     })
    
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(receivedCurrency, self.mockedCurrency)
    XCTAssertNotNil(receivedCurrency)
    }
  
  func testGettingSavedCurrency() {
    let expectedCurrency = getStoredCurrency()
    let currency = service.getStoredCurrencyExchange()
    
    XCTAssertEqual(expectedCurrency, currency)
    XCTAssertNotNil(expectedCurrency)
  }

}
