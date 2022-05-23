//
//  extension.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 23/05/2022.
//

import Foundation

extension Weather {
  
  struct WeatherDescription: Decodable {
    let description: String
    let icon: String
    
    static var emptyDescription: WeatherDescription{ WeatherDescription(description: "", icon: "")}
    
  }
}

extension Weather: Equatable{
  
  static func ==(lhs: Weather, rhs: Weather) -> Bool{
    return lhs.locationName == rhs.locationName && lhs.temperature == rhs.temperature
  }
}
