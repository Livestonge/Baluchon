//
//  TranslateViewModelTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 01/03/2022.
//

import XCTest
import RxSwift
@testable import Baluchon

class WeatherViewModelTest: XCTestCase {
    
    var viewModel: WeatherManager?
  
    override func setUp() {
      viewModel = WeatherManager(initialeState: .init(),
                                   iniatialAction: .none,
                                   service: MockWeatherRestApi())
      super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()

    }
  
  func testActionChanges() {
    let expectation = XCTestExpectation(description: "City name")
    var weatherBaseState: WeatherBaseState?
//  When
    let cityName = "Oslo"
    viewModel?.action = .didProvideCity(cityName)
//  Then
    _ = self.viewModel?.getStateChanges()
                        .debounce(.microseconds(20), scheduler: MainScheduler.instance)
                        .subscribe(onNext: { state in
                         weatherBaseState = state
                         expectation.fulfill()
                       })
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(weatherBaseState?.localWeather.locationName, "Paris")
  }
  
  func testLocationChanges() throws {
//    When
    let expectation = XCTestExpectation(description: "") 
    let location = Location(latitude: 23.433, longitude: 45.456)
    viewModel?.action = .didUpdateUser(location)
    var receivedCityName: String = ""
//    Then
    _ = self.viewModel?.getStateChanges()
                       .subscribe(onNext: { state in
                         receivedCityName = state.localWeather.locationName
                         expectation.fulfill()
                       })
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(receivedCityName, "Paris")
  }

}

