//
//  TestWeatherController.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 07/03/2022.
//

import XCTest
import RxSwift
import UIKit
@testable import Baluchon

class TestWeatherController: XCTestCase {

    var sut: WeatherViewController!
  
    override func setUpWithError() throws {
      try super.setUpWithError()
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      sut = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
      sut.weatherViewModel = MockWeatherViewModel()
      sut.loadViewIfNeeded()
      
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
  
  func testCityTextField(){
//    When
    let city = sut.weatherViewModel.getCurrentState().localWeather.locationName
//    Then
    let displayedCity = sut.textFieldCity.text ?? ""
    XCTAssertEqual(city, displayedCity)
  }
  
  func testTemperatureTextField(){
    //    When
    let temperature = Int(sut.weatherViewModel.getCurrentState().localWeather.temperature).description + "ºC"
    //    Then
    let displayedTemperature = sut.labelTemperature.text ?? ""
    XCTAssertEqual(temperature, displayedTemperature)
  }
  
  func testWeatherRequest(){
//    When
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
    sut.textFieldCity.text = "Berlin"
    let gesture = sut.gestureRecognizerSearchImage!
    sut.didTapOnSearchButton(gesture)
    
//    Then
    delay(2){ [weak self] in
      let text = self?.sut.textFieldCity.text
      XCTAssertEqual(text, "Paris")
    }
  }

}

class MockWeatherViewModel: WeatherViewModel{
  
  class Service: WeatherAPIProvider{
    func getWeatherFor(city: String) -> Observable<Weather> {
      .just(Weather(locationName: "Paris",
                    temperature: 20,
                    humidity: 10,
                    description: .emptyDescription))
    }
    
    func getLocalWeather(for location: Location) -> Observable<Weather> {
      .just(Weather(locationName: "Paris",
                    temperature: 20,
                    humidity: 10,
                    description: .emptyDescription))
    }
  }
  
  init(){
    
    super.init(initialeState: WeatherBaseState(),
               iniatialAction: .didProvideCity("Oslo"),
               service: Service())
  }
}
