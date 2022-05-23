////
////  BaluchonTests.swift
////  BaluchonTests
////
////  Created by Awaleh Moussa Hassan on 17/01/2022.
////
//
//import XCTest
//import RxSwift
//@testable import Baluchon
//
//class WeatherAPIProviderTests: XCTestCase {
//
//    var provider : WeatherAPIProvider?
//    let bag = DisposeBag()
//  
//    lazy var mockedWeather: Weather = {
//      return try! JSONDecoder().decode(Weather.self, from: weatherData!)
//    }()
//  
//    override func setUpWithError() throws {
//        provider = MockWeatherService()
//        try super.setUpWithError()
//    }
//
//    override func tearDownWithError() throws {
//        provider = nil
//        try super.tearDownWithError()
//    }
//  
//  func testGetWeatherByCity(){
//    
//    let expectation = self.expectation(description: "weather for city")
//    var receivedWeather: Weather?
//    
//    provider?.getWeatherFor(city: "Paris")
//            .subscribe(onNext: { weather in
//              receivedWeather = weather
//              expectation.fulfill()
//            })
//            .disposed(by: bag)
//    
//    waitForExpectations(timeout: 2, handler: nil)
//    XCTAssertEqual(receivedWeather!, self.mockedWeather)
//  }
//  
//  func testGetWeatherByLocation(){
//    
//    let expection = self.expectation(description: "weather for a location")
//    let parisLocation = Location(latitude: 48.8534, longitude: 2.3488)
//    var receivedWeather: Weather?
//    
//    provider?.getLocalWeather(for: parisLocation)
//             .subscribe(onNext: { weather in
//               receivedWeather = weather
//               expection.fulfill()
//             })
//             .disposed(by: bag)
//    
//    waitForExpectations(timeout: 2, handler: nil)
//    XCTAssertEqual(receivedWeather!, self.mockedWeather)
//  }
//
//}
