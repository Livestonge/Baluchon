//
//  WeatherBaseState.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 20/02/2022.
//

import Foundation

struct WeatherBaseState{
  
  var localWeather: Weather = Weather.initialeWeatherState
  var error: BaluchonError? = nil
}

enum WeatherBaseAction{
  
  case didProvideCity(String)
  case didUpdateUser(Location)
  case none
}
