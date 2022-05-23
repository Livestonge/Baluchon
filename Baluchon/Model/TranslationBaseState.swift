//
//  TranslationBaseState.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 07/02/2022.
//

import Foundation

struct TranslationBaseState{
  
  var textTotranslate = ""
  var targetLanguage: Language = .en
  var translatedText = ""
  var translationError: BaluchonError? = nil
}

enum TranslationBaseStateAction{
  case didChooseLanguage(Language, String)
  case didProvideWrongInput(BaluchonError)
  case none
}


extension TranslationBaseState: Equatable {
  
  static func ==(lhs: TranslationBaseState, rhs: TranslationBaseState) -> Bool{
    return lhs.textTotranslate == rhs.textTotranslate
  }
}
