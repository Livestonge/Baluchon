//
//  Weather_deleagate_conformance.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 24/05/2022.
//

import Foundation

extension WeatherViewController: WeatherDataDelegate {
  
  func didReceive(_ weather: Weather) {
    subscribeToMainThread { [weak self] in
      self?.textFieldCity.text = weather.locationName.isEmpty == false ? "\(weather.locationName)" : ""
      self?.labelTemperature.text = "\(Int(weather.temperature.rounded()))ºC"
      self?.labelHumidity.text = "\(weather.humidity)%"
      self?.labelWeatherDescription.text = weather.description.description.capitalized
      self?.labelIcon.text = weather.description.icon
    }
  }
  
  func didFailWith(_ error: BaluchonError) {
    subscribeToMainThread { [weak self] in
      self?.presentAlertFor(error)
    }
  }
  
  private func presentAlertFor(_ error: BaluchonError){
    let alertCtrl = BaluchonAlert(error: error).controller
    self.present(alertCtrl, animated: true)
  }
  
  
}
