//
//  OpenWeatherAPITest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 27/02/2022.
//

import XCTest
import RxSwift
@testable import Baluchon

class OpenWeatherAPITest: XCTestCase {

  var provider : OpenWeatherAPIProviding!
  let bag = DisposeBag()

  lazy var mockedWeather: Weather? = {
    guard let openWeather = try? JSONDecoder().decode(OpenWeather.self, from: weatherData!)
    else { return nil }
    return openWeather.mapToWeather()
  }()

  override func setUp() {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [UrlSessionProxy.self]
    let session = URLSession(configuration: configuration)
    provider = OpenWeatherAPIProviding(session: session)
    super.setUp()
  }

  override func tearDown() {
      super.tearDown()
      provider?.session.configuration.protocolClasses = nil
      provider = nil
     UrlSessionProxy.reset()
  }
  
  private func configureUrlSessionProxy() {
    let response = HTTPURLResponse(url: URL(string: "www.vg.no")!,
                                   statusCode: 200,
                                   httpVersion: nil,
                                   headerFields: ["Content-Type": "application/json"])!
    
    UrlSessionProxy.requestHandler = { _ throws -> (Data, HTTPURLResponse) in
      return (weatherData!, response)
    }
    
  }

  func testURL() throws {
    let urlString = "http://api.openweathermap.org/data/2.5/weather?appid=\(openWeather_Api_Key)&units=metric&lang=fr"
    let url = try XCTUnwrap(URL(string: urlString))
    XCTAssertEqual(url, try XCTUnwrap(provider?.components.url))
  }

func testGetWeatherByCity(){

  let expectation = XCTestExpectation(description: "weather for city")
  var receivedWeather: Weather?
  configureUrlSessionProxy()
  
  _ = provider.getWeatherFor(city: "Paris")
           .subscribe(onNext: { weather in
            receivedWeather = weather
            expectation.fulfill()
           })

  wait(for: [expectation], timeout: 2)
  XCTAssertEqual(receivedWeather, self.mockedWeather)
}

func testGetWeatherByLocation(){

  let expection = XCTestExpectation(description: "weather for a location")
  let parisLocation = Location(latitude: 48.8534, longitude: 2.3488)
  var receivedWeather: Weather?
  configureUrlSessionProxy()

  _ = provider?.getLocalWeather(for: parisLocation)
           .subscribe(onNext: { weather in
             receivedWeather = weather
             expection.fulfill()
           })

  wait(for: [expection], timeout: 2)
  let mocked = self.mockedWeather
  XCTAssertEqual(receivedWeather!, mocked!)
}
  
  func testMockData() throws {
    let data = try XCTUnwrap(provider?.mock)
    let weather = try? JSONDecoder().decode(OpenWeather.self, from: data).mapToWeather()
    XCTAssertEqual(weather, self.mockedWeather)
  }
}
