//
//  TranslationViewModelTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 28/02/2022.
//

import XCTest
@testable import Baluchon

class TranslationViewModelTest: TranslateAPITest {
  
  var viewModel: TranslationViewModel?

  override func setUpWithError() throws {
    viewModel = TranslationViewModel(initialState: .init(),
                                     initialAction: .none,
                                     service: GoogleTranslateServiceProviding())
    try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testActionChanges() throws {
//        When
      let textToTranslate = "Ceci est un test"
      let language: Language = .en
      viewModel?.action = .didChooseLanguage(language, textToTranslate)
//      then
      delay(2){ [weak self] in
        let currentState = self?.viewModel?.getCurrentState()
        XCTAssertEqual(textToTranslate, currentState?.textTotranslate)
        XCTAssertEqual(language, currentState?.targetLanguage)
      }
    }
  
  func testStateChanges(){
//  When
    let text = "Testing...."
    viewModel?.updateState{ state in
      state.textTotranslate = text
    }
//  Then
    let state = viewModel?.getCurrentState()
    XCTAssertEqual(text, state?.textTotranslate)
  }
  
  func testTranslatedText(){
 // When
    let textToTranslate = "Ceci est un test"
    let language: Language = .en
    viewModel?.action = .didChooseLanguage(language, textToTranslate)
    
//  Then
    delay(2){ [weak self] in
      let currentState = self?.viewModel?.getCurrentState()
      XCTAssertEqual(self?.translated?.text, currentState?.translatedText)
    }
    
  }

}
