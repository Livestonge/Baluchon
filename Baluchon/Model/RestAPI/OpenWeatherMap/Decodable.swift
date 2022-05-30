//
//  Decodable.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 23/05/2022.
//

import Foundation


extension OpenWeather: Decodable {
  
  enum OuterCodingKeys: String, CodingKey{
    case main
    case weather
    case locationName = "name"
  }
  enum InnerCodingKeys: String, CodingKey{
    case temperature = "temp"
    case humidity
  }
  
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

extension OpenWeather.WeatherDescription: Decodable {
  
  enum DescriptionKeys: String, CodingKey{
    case description
    case iconCode = "icon"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DescriptionKeys.self)
    self.description = try container.decode(String.self, forKey: .description)
    self.iconCode = try container.decode(String.self, forKey: .iconCode)
  }
}
