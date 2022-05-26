//
//  WeatherViewModel.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 20/02/2022.
//

import Foundation
import RxSwift

class WeatherManager: BaseStateActionManager<WeatherBaseState, WeatherBaseAction>{
  
  let service: WeatherAPIProvider
  weak var delegate: WeatherDataDelegate?
  let dispose = DisposeBag()
  
  init(initialeState: WeatherBaseState, iniatialAction: WeatherBaseAction, service: WeatherAPIProvider){
    self.service = service
    super.init(initialState: initialeState, initialAction: iniatialAction)
    
    getActionChanges{ action in
      switch action{
      case .didProvideCity(let city):
        self.getWeatherFor(city: city)
      case .didUpdateUser(let location):
        self.getLocalWeather(for: location)
      case .none:
        self.getUserLocation()
      }
    }
    
    getStateChanges()
      .map(\.localWeather)
      .subscribe(onNext: { [weak self] weather in
        self?.delegate?.didReceive(weather)
      })
      .disposed(by: disposeBag)
    
    getStateChanges()
      .compactMap(\.error)
      .subscribe(onNext: { [weak self] error in
        self?.delegate?.didFailWith(error)
      })
      .disposed(by: disposeBag)
  }
  
  private func getWeatherFor(city: String){
    
    service.getWeatherFor(city: city)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] weather in
        self?.updateState{ state in
          state.localWeather = weather
          state.error = nil
        }
      }, onError: { [weak self] error in
        self?.updateState{ state in
          state.error = BaluchonError(error)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func getLocalWeather(for location: Location){
    service.getLocalWeather(for: location)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] weather in
        self?.updateState{ state in
          state.localWeather = weather
          state.error = nil
        }
      }, onError: {[weak self] error in
        self?.updateState{ state in
          state.error = BaluchonError(error)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func getUserLocation(){
    
    DispatchQueue.main.asyncAfter(deadline: .now()+2){ [weak self] in
      guard let savedUserData = UserDefaults.standard.data(forKey: "userLocation"),
      let location = try? JSONDecoder().decode(Location.self, from: savedUserData) else {
        print("Failed to load Location")
        return }
      self?.action = .didUpdateUser(location)
    }
    
  }
}
