//
//  OpenWeatherAPI.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 15/02/2022.
//

import Foundation
import RxSwift

protocol WeatherAPIProvider{
  func getWeatherFor(city: String) -> Observable<Weather>
  func getLocalWeather(for location: Location) -> Observable<Weather>
}

class OpenWeatherAPIProviding: RestApi, WeatherAPIProvider {
  
  let session: URLSession
  
  init(session: URLSession = .shared){
    self.session = session
  }
  var mock = weatherData!
  
  var components: URLComponents{
    var components = URLComponents()
    components.scheme = "http"
    components.host = "api.openweathermap.org"
    components.path = "/data/2.5/weather"
    let queryItems = [
      URLQueryItem(name: "appid", value: openWeather_Api_Key),
      URLQueryItem(name: "units", value: "metric"),
      URLQueryItem(name: "lang", value: "fr")
    ]
    components.queryItems = queryItems
    return components
  }
 
  func getWeatherFor(city: String) -> Observable<Weather>{
    let query = URLQueryItem(name: "q", value: city)
    var components = self.components
    components.queryItems?.append(query)
    let url = components.url!
    
    return makeRequestFor(url: url)
                    .subscribe(on: MainScheduler.instance)
                    .decode(type: OpenWeather.self, decoder: JSONDecoder())
                    .map{ $0.mapToWeather() }
  }
  
  func getLocalWeather(for location: Location) -> Observable<Weather> {
    let locationQueries = [
      URLQueryItem(name: "lat", value: "\(location.latitude)"),
      URLQueryItem(name: "lon", value: "\(location.longitude)")
    ]
    var components = self.components
    components.queryItems! += locationQueries
    let url = components.url!
    return makeRequestFor(url: url)
                        .decode(type: OpenWeather.self, decoder: JSONDecoder())
                        .map{ Weather(locationName: $0.locationName,
                                      temperature: $0.temperature,
                                      humidity: $0.humidity,
                                      description: .init(description: $0.description.description,
                                                         icon: $0.description.icon))}
  }
}
