//
//  TranslationViewModelTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 28/02/2022.
//

import XCTest
import RxBlocking
import RxSwift
@testable import Baluchon

class TranslationViewModelTest: XCTestCase {
  
  var viewModel: TranslationManager?

  override func setUpWithError() throws {
    viewModel = TranslationManager(initialState: .init(),
                                     initialAction: .none,
                                     service: MockGoogleRestApi())
    try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testActionChanges() throws {
      let expectation = XCTestExpectation(description: "test action changes")
//        When
      let textToTranslate = "Ceci est un test"
      var currentState: TranslationBaseState?
      let language: Language = .en
      viewModel?.action = .didChooseLanguage(language, textToTranslate)
//      then
      _ = self.viewModel?.getStateChanges()
                         .subscribe(onNext: { state in
                           currentState = state
                           expectation.fulfill()
                         })
      
      wait(for: [expectation], timeout: 2)
      XCTAssertEqual(currentState?.textTotranslate, textToTranslate)
      XCTAssertEqual(currentState?.targetLanguage, language)
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
    let expectation = XCTestExpectation(description: "test translation")
    let textToTranslate = "Ceci est un test"
    var translatedText: String?
    let language: Language = .en
    viewModel?.action = .didChooseLanguage(language, textToTranslate)

//  Then
    _ = self.viewModel?.getStateChanges()
                       .subscribe(onNext: { state in
                         translatedText = state.translatedText
                         expectation.fulfill()
                       })
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(translatedText, "Write your text here")

  }

}
