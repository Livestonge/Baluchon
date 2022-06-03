//
//  Mock_weather_restApi.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 03/06/2022.
//

import Foundation
import RxSwift
@testable import Baluchon

class MockWeatherRestApi: OpenWeatherAPIProviding{
  
  private var weather: OpenWeather?{
    try? JSONDecoder().decode(OpenWeather.self, from: weatherData!)
  }
  
  override func getWeatherFor(city: String) -> Observable<Weather> {
    .just(weather!.mapToWeather())
  }
  
  override func getLocalWeather(for location: Location) -> Observable<Weather> {
    .just(weather!.mapToWeather())
  }
}
