//
//  CurrencyManager.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 31/01/2022.
//

import Foundation
import RxSwift
import RxRelay

class CurrencyViewModel: BaseStateActionViewModel<CurrentBaseState, CurrencyBaseStateAction>{
  
  private let fixerService: CurrencyServiceProvider
  
  init(initialState: CurrentBaseState,
       initialAction: CurrencyBaseStateAction,
       service: CurrencyServiceProvider) {
    
    self.fixerService = service
    super.init(initialState: initialState, initialAction: initialAction)
    
    getActionChanges{ [weak self] action in
      switch action{
      case .hasTappedValue(let value):
        self?.makeConversion(forValue: value)
      case .didSwitchedCurrency(let userInput):
        self?.didSwitchedBaseCurrencyWith(userInput: userInput)
      }
    }
  }
  
  private func makeConversion(forValue value: Double){
    let currentState = getCurrentState()
    if currentState.rate != 0 {
      self.updateConvertedValue(value)
      return
    }
    fixerService.getCurrencyExchange()
                .map(\.baseRate)
                .subscribe(onNext: { [weak self] rate in
                  self?.updateState{ state in
                    state.rate = rate
                  }
                  self?.updateConvertedValue(value)
                }, onError: { error in
                  self.updateState{ $0.error = BaluchonError(error) }
                })
                .disposed(by: disposeBag)
  }
  
  private func didSwitchedBaseCurrencyWith(userInput input: Double){
        self.updateState{ state in
          state.baseCurrency = state.baseCurrency == .EUR ? .USD : .EUR
        }
        self.updateConvertedValue(input)
  }
  
  private func updateConvertedValue( _ newValue: Double){
    updateState{ state in
      if state.baseCurrency == .EUR {
        state.convertedValue = newValue * state.rate
      }else{
        state.convertedValue = newValue / state.rate
      }
    }
  }
}
