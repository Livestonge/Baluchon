//
//  extension.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 23/05/2022.
//

import Foundation


extension OpenWeather {
  
  struct WeatherDescription {
    let description: String
    let iconCode: String
    
    var icon: String {
      return self.iconNameToChar(iconCode: self.iconCode)
    }
    
    static var emptyDescription: WeatherDescription{ WeatherDescription(description: "", iconCode: "")}
    
    private func iconNameToChar(iconCode: String) -> String {
      switch iconCode {
      case "01d":
        return "\u{2600}"
      case "01n":
        return "\u{2600}"
      case "02d":
        return "\u{1F324}"
      case "02n":
        return "\u{f104}"
      case "03d", "03n":
        return "\u{2601}"
      case "04d", "04n":
        return "\u{1F4A8}"
      case "09d", "09n":
        return "\u{1F327}"
      case "10d", "10n":
        return "\u{1F326}"
      case "11d", "11n":
        return "\u{1F329}"
      case "13d", "13n":
        return "\u{2744}"
      case "50d", "50n":
        return "\u{1F32B}"
      default:
        return "E"
      }
    }
  }
}

extension OpenWeather: Equatable{
  
  static func ==(lhs: OpenWeather, rhs: OpenWeather) -> Bool{
    return lhs.locationName == rhs.locationName && lhs.temperature == rhs.temperature
  }
}
