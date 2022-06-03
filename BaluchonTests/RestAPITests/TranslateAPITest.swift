//
//  TranslateAPITest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 28/02/2022.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Baluchon

class TranslateAPITest: XCTestCase {
  var service: GoogleTranslateServiceProviding!
  
  lazy var translated: TranslatedResponse? = {
    let data = googleTranslatedData!
    return try? JSONDecoder().decode(GoogleTranslatedResponse.self, from: data).mapToTranslatedResponse()
  }()
  
  override func setUp(){
    UrlSessionProxy.reset()
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [UrlSessionProxy.self]
    let session = URLSession(configuration: configuration)
    service = GoogleTranslateServiceProviding(session: session)
    super.setUp()
    }

  override func tearDown(){
        super.tearDown()
        service.session.configuration.protocolClasses = nil
        service = nil
        
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
    let expectation = XCTestExpectation(description: "Translation")
    var receivedTranslatedResponse: TranslatedResponse?
    let response = HTTPURLResponse(url: service!.components.url!,
                                   statusCode: 200,
                                   httpVersion: nil,
                                   headerFields: ["Content-Type": "application/json"])!
    
    UrlSessionProxy.requestHandler = { [response] request throws -> (Data, HTTPURLResponse) in
      return (googleTranslatedData!, response)
    }
    
    _ = service.translate(text: "Ceci est un test", from: .fr, to: .en)
              .subscribe(onNext: { translatedResponse in
                receivedTranslatedResponse = translatedResponse
                expectation.fulfill()
              })
    
    wait(for: [expectation], timeout: 2)
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
