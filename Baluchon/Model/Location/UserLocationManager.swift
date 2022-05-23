//
//  UserLocationManager.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 21/02/2022.
//

import Foundation
import CoreLocation

class UserLocationManager: NSObject {
  
  private let locationManger: CLLocationManager
  
  override init(){
    locationManger = CLLocationManager()
    super.init()
    locationManger.delegate = self
    locationManger.requestWhenInUseAuthorization()
    locationManger.startUpdatingLocation()
  }
  
  func startUpdatingLocation(){
    self.locationManger.startUpdatingLocation()
  }
  
  private func saveUser(location: Location) throws{
    let encoder = JSONEncoder()
    let data = try encoder.encode(location)
    UserDefaults.standard.set(data, forKey: "userLocation")
  }
}

extension UserLocationManager: CLLocationManagerDelegate{
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    switch status{
    case .authorizedAlways, .authorizedWhenInUse:
      startUpdatingLocation()
    case .denied, .restricted, .notDetermined:
      manager.requestWhenInUseAuthorization()
    default: break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    let userLocation = Location(latitude: location.coordinate.latitude.magnitude,
                                longitude: location.coordinate.longitude.magnitude)
    try? saveUser(location: userLocation)
    manager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
}
