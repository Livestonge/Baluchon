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

  var provider : OpenWeatherAPIProviding?
  let bag = DisposeBag()

  lazy var mockedWeather: Weather? = {
    return try? JSONDecoder().decode(Weather.self, from: weatherData!)
  }()

  override func setUpWithError() throws {
      provider = OpenWeatherAPIProviding()
      try super.setUpWithError()
  }

  override func tearDownWithError() throws {
      provider = nil
      try super.tearDownWithError()
  }

  func testURL() throws {
    let urlString = "http://api.openweathermap.org/data/2.5/weather?appid=\(openWeather_Api_Key)&units=metric&lang=fr"
    let url = try XCTUnwrap(URL(string: urlString))
    XCTAssertEqual(url, try XCTUnwrap(provider?.components.url))
  }

func testGetWeatherByCity(){

  let expectation = self.expectation(description: "weather for city")
  var receivedWeather: Weather?

  provider?.getWeatherFor(city: "Paris")
           .subscribe(onNext: { weather in
            receivedWeather = weather
            expectation.fulfill()
           })
           .disposed(by: bag)

  waitForExpectations(timeout: 2, handler: nil)
  XCTAssertEqual(receivedWeather, self.mockedWeather)
}

func testGetWeatherByLocation(){

  let expection = self.expectation(description: "weather for a location")
  let parisLocation = Location(latitude: 48.8534, longitude: 2.3488)
  var receivedWeather: Weather?

  provider?.getLocalWeather(for: parisLocation)
           .subscribe(onNext: { weather in
             receivedWeather = weather
             expection.fulfill()
           })
           .disposed(by: bag)

  waitForExpectations(timeout: 2, handler: nil)
  XCTAssertEqual(receivedWeather, self.mockedWeather)
}
  
  func testMockData() throws {
    let data = try XCTUnwrap(provider?.mock)
    let weather = try JSONDecoder().decode(Weather.self, from: data)
    XCTAssertEqual(weather, self.mockedWeather)
  }
}
