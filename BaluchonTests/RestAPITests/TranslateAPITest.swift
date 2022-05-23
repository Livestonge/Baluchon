//
//  TranslateAPITest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 28/02/2022.
//

import XCTest
import RxSwift
@testable import Baluchon

class TranslateAPITest: XCTestCase {
  var service: GoogleTranslateServiceProviding?
  
  lazy var translated: TranslatedResponse? = {
    let data = googleTranslatedData!
    return try? JSONDecoder().decode(TranslatedResponse.self, from: data)
  }()
  
  override func setUpWithError() throws {
      service = GoogleTranslateServiceProviding()
      try super.setUpWithError()
    }

  override func tearDownWithError() throws {
        service = nil
        try super.tearDownWithError()
    }
  
  func testURL() throws {
    let urlString = "https://translation.googleapis.com/language/translate/v2?key=\(google_Translate_Api_Key)&format=text&model=base"
    let url = try XCTUnwrap(URL(string: urlString))
    XCTAssertEqual(url, self.service?.components.url)
  }
  
  func testRequestWithArguments() throws {
    
    let textToTranslate = "Ceci est un test!!"
    let targetLanguage: Language = .en
    var urlString = "https://translation.googleapis.com/language/translate/v2?key=\(google_Translate_Api_Key)&format=text&model=base"
    var components = URLComponents(string: urlString)
    let queries = [URLQueryItem(name: "q", value: textToTranslate),
                   URLQueryItem(name: "target", value: "\(targetLanguage)"),
                   URLQueryItem(name: "source", value: "fr")
    ]
    components?.add(queries: queries)
    let testUrl = try XCTUnwrap(components?.url)
    let url = service?.getUrlWith(text: textToTranslate, target: targetLanguage, source: .fr)
    XCTAssertEqual(url, testUrl)
  }
  
  func testTranslate() throws{
    let expectation = self.expectation(description: "Translation")
    var receivedTranslatedResponse: TranslatedResponse?
    
    service?.translate(text: "Ceci est un test", from: .fr, to: .en)
            .subscribe(onNext: { translated in
              receivedTranslatedResponse = translated
              expectation.fulfill()
            })
    waitForExpectations(timeout: 2, handler: nil)
    XCTAssertEqual(receivedTranslatedResponse, translated)
  }
  

}

extension URLComponents{
  mutating func add(queries: [URLQueryItem]){
    for query in queries{
      queryItems?.append(query)
    }
  }
}
