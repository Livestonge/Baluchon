//
//  Weather.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 15/02/2022.
//

import Foundation

struct Weather {
  
  let locationName: String
  let temperature: Double
  let humidity: Int
  let description: WeatherDescription
  
  static var initialeWeatherState: Weather {
    return Weather(locationName: "City not found", temperature: 0, humidity: 0, description: .emptyDescription)
  }
  
}
