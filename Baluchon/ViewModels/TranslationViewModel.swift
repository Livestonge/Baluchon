//
//  TranslatingManager.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 07/02/2022.
//

import Foundation
import RxSwift
import RxRelay


class TranslationViewModel: BaseStateActionManager<TranslationBaseState, TranslationBaseStateAction>{
  
  let apiService: TranslateServiceProvider
  
  init(initialState: TranslationBaseState,
       initialAction: TranslationBaseStateAction,
       service: TranslateServiceProvider) {
    
    self.apiService = service
    super.init(initialState: initialState, initialAction: initialAction)
    
    getActionChanges{ action in
      switch action{
      case .didChooseLanguage(let language, let text):
        self.didChoose(language, for: text)
      case .didProvideWrongInput(let customError):
        self.handle(customError)
      default: break
      }
    }
  }
  
  private func handle(_ error: BaluchonError){
    updateState{ state in
      state.translationError = error
    }
  }
  private func didChoose(_ language: Language, for text: String){
    
    updateState{ state in
      state.textTotranslate = text
      state.targetLanguage = language
      state.translationError = nil
    }
    makeGoogleRequest()
  }
  private func makeGoogleRequest(){
    let state = getCurrentState()
    let fromLanguage: Language = state.targetLanguage == .fr ? .en : .fr
    apiService.translate(text: state.textTotranslate, from: fromLanguage, to: state.targetLanguage)
                        .subscribe(onNext: { [weak self] translatedText in
                          self?.updateState{ state in
                            state.translatedText = translatedText.text
                          }
                        }, onError: { [weak self] error in
                          self?.updateState{ state in
                            state.translationError = BaluchonError(error)
                          }
                        })
                        .disposed(by: disposeBag)
    
  }
}
