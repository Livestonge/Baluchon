//
//  Dependency handler.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 11/02/2022.
//

import Foundation
import Swinject
import UIKit

class DependencyHandler{
  
  let container: Container
  
  init(container: Container){
    self.container = container
    
    registerTranslationsDependencies(container: container)
    registerCurrenciesDependencies(container: container)
    registerWeatherDependencies(container: container)
    
  }
  
  func injectDependencies(){
    
    self.container.storyboardInitCompleted(ViewController.self){ resolver, controller in
      let manager = resolver.resolve(CurrencyManager.self)!
      controller.currencyManager = manager
    }
    
    self.container.storyboardInitCompleted(MainTranslationControllerViewController.self){ resolver, controller in
      let manager = resolver.resolve(TranslationViewModel.self)!
      controller.translationViewModel = manager
    }
    
    self.container.storyboardInitCompleted(WeatherViewController.self){ resolver, controller in
      let manager = resolver.resolve(WeatherManager.self)!
      controller.weatherManager = manager
    }
  
}
  private func registerTranslationsDependencies(container: Container){
    
    container.register(TranslateServiceProvider.self){ _ in
      return GoogleTranslateServiceProviding()
                                                    }
    
    container.register(TranslationViewModel.self){ resolver in
      
      let service = resolver.resolve(TranslateServiceProvider.self)!
      return TranslationViewModel(initialState: TranslationBaseState(),
                                  initialAction: .none,
                                  service: service)
    }
  }
  
  private func registerCurrenciesDependencies(container: Container){
    
    container.register(CurrencyServiceProvider.self){ _ in
      return FixerServiceProviding()
    }
    
    container.register(CurrencyManager.self){ resolver in
      
      let service = resolver.resolve(CurrencyServiceProvider.self)!
      return CurrencyManager(initialState: CurrentBaseState(),
                               initialAction: .hasTappedValue(100.0),
                               service: service)
    }
  }
  
  private func registerWeatherDependencies(container: Container){
    
    container.register(WeatherAPIProvider.self){ _ in
      return OpenWeatherAPIProviding()
    }
    
    container.register(WeatherManager.self){ resolver in
      
      let service = resolver.resolve(WeatherAPIProvider.self)!
      
      return WeatherManager(initialeState: WeatherBaseState(),
                              iniatialAction: .none,
                              service: service)
    }
  }
}
