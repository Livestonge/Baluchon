//
//  Weather.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 15/02/2022.
//

import Foundation

struct Weather: Decodable {
  
  enum OuterCodingKeys: String, CodingKey{
    case main
    case weather
    case locationName = "name"
  }
  enum InnerCodingKeys: String, CodingKey{
    case temperature = "temp"
    case humidity
  }
  
  let locationName: String
  let temperature: Double
  let humidity: Int
  let description: WeatherDescription
  
  static var initialeWeatherState: Weather {
    return Weather(locationName: "City not found", temperature: 0, humidity: 0, description: .emptyDescription)
  }
  
}

extension Weather{
  
  init(from decoder: Decoder) throws {
    do{
      let container = try decoder.container(keyedBy: OuterCodingKeys.self)
      self.locationName = try container.decode(String.self, forKey: .locationName)
      let weatherArray = try container.decode([WeatherDescription].self, forKey: .weather)
      guard let description = weatherArray.first else { fatalError("Got empty array!!!") }
      self.description = description
      let nestedContainer = try container.nestedContainer(keyedBy: InnerCodingKeys.self, forKey: .main)
      self.temperature = try nestedContainer.decode(Double.self, forKey: .temperature)
      self.humidity = try nestedContainer.decode(Int.self, forKey: .humidity)
    }catch{
      throw BaluchonError.decodingError
    }
  }
}


extension Weather {
  
  struct WeatherDescription: Decodable {
    let description: String
    private let iconCode: String
    
    enum DescriptionKeys: String, CodingKey{
      case description
      case iconCode = "icon"
    }
    
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

extension Weather.WeatherDescription{
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DescriptionKeys.self)
    self.description = try container.decode(String.self, forKey: .description)
    self.iconCode = try container.decode(String.self, forKey: .iconCode)
  }
}

extension Weather: Equatable{
  
  static func ==(lhs: Weather, rhs: Weather) -> Bool{
    return lhs.locationName == rhs.locationName && lhs.temperature == rhs.temperature
  }
}
