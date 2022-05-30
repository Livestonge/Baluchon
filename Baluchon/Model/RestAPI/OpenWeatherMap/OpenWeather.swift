//
//  OpenWeather.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 23/05/2022.
//

import Foundation

struct OpenWeather {
  
  let locationName: String
  let temperature: Double
  let humidity: Int
  let description: WeatherDescription
  
  static var initialeWeatherState: OpenWeather {
    return OpenWeather(locationName: "City not found", temperature: 0, humidity: 0, description: .emptyDescription)
  }
  
  func mapToWeather() -> Weather{
    Weather(locationName: locationName,
            temperature: temperature,
            humidity: humidity,
            description: .init(description: description.description,
                               icon: description.icon))
  }
  
}

