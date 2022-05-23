////
////  StubGoogleService.swift
////  Baluchon
////
////  Created by Awaleh Moussa Hassan on 11/02/2022.
////
//
//import Foundation
//import RxSwift
//
//class MockTranslateService: RestApi, TranslateServiceProvider{
//  
//  func translate(text: String, from: Language, to: Language) -> Observable<TranslatedResponse> {
//    return Observable.of(googleTranslatedData!)
//                     .decode(type: TranslatedResponse.self, decoder: JSONDecoder())
//  }
//  
//}
//
//class MockCurrencyService: RestApi,CurrencyServiceProvider{
//  
//  lazy private var dateFormatter: DateFormatter = {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    return dateFormatter
//  }()
//  
//  func getCurrencyExchange() -> Observable<CurrencyExchange> {
//    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = .formatted(dateFormatter)
//    return Observable.of(jsonData!)
//                     .decode(type: CurrencyExchange.self, decoder: decoder)
//  }
//  
//}
//
//class MockWeatherService: RestApi, WeatherAPIProvider {
//  
//  func getWeatherFor(city: String) -> Observable<Weather> {
//    return Observable.of(weatherData!)
//                     .decode(type: Weather.self, decoder: JSONDecoder())
//  }
//  
//  func getLocalWeather(for location: Location) -> Observable<Weather> {
//    return self.getWeatherFor(city: "")
//  }
//  
//  
//}
