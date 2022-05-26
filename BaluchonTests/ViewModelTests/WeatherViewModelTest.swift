//
//  TranslateViewModelTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 01/03/2022.
//

import XCTest
import RxSwift
@testable import Baluchon

class WeatherViewModelTest: OpenWeatherAPITest {
    
    var viewModel: WeatherManager?
  
    override func setUpWithError() throws {
      viewModel = WeatherManager(initialeState: .init(),
                                   iniatialAction: .none,
                                   service: OpenWeatherAPIProviding())
      try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
  
  func testActionChanges() {
    var receivedCityName: String = ""
//  When
    let cityName = "Oslo"
    viewModel?.action = .didProvideCity(cityName)
//  Then
    delay(2){
      do{
        receivedCityName = try XCTUnwrap(self.viewModel?.getCurrentState().localWeather.locationName)
        XCTAssertEqual(receivedCityName, "Paris")
      }catch{
        XCTFail()
      }
    }
  }
  
  func testLocationChanges() {
//    When
    let location = Location(latitude: 23.433, longitude: 45.456)
    viewModel?.action = .didUpdateUser(location)
    var receivedCityName: String = ""
//    Then
    delay(2){
      do{
        receivedCityName = try XCTUnwrap(self.viewModel?.getCurrentState().localWeather.locationName)
        XCTAssertEqual(receivedCityName, "Paris")
      }catch{
        XCTFail()
      }
    }
  }

}

