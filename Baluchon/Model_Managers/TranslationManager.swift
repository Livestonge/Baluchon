//
//  TranslatingManager.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 07/02/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol TranslationSourceDelegate: AnyObject, Failable{
  func getUserTranslation(_ translation: (String, String))
}

class TranslationManager: BaseStateActionManager<TranslationBaseState, TranslationBaseStateAction>{
  
  let apiService: TranslateServiceProvider
  weak var delegate: TranslationSourceDelegate?
  
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
    
    getStateChanges()
                    .filter { $0.translatedText.isEmpty == false && $0.translationError == nil}
                    .map({ state -> (String, String) in
                      return (state.translatedText, state.textTotranslate)
                    })
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] translatedText, sourceText in
                      let translation = (translatedText, sourceText)
                      self?.delegate?.getUserTranslation(translation)
                    })
                    .disposed(by: disposeBag)
    
    getStateChanges()
                    .compactMap(\.translationError)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] error in
                      self?.delegate?.didFailWith(error)
                    })
                    .disposed(by: disposeBag)
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
