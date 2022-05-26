//
//  TranslationControllersTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 07/03/2022.
//

import XCTest
import RxSwift
@testable import Baluchon

class TranslationControllersTest: XCTestCase {

  var sourceSut: MainTranslationControllerViewController!
  var navigationSut: UINavigationController!
  
    override func setUpWithError() throws {
      try super.setUpWithError()
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      navigationSut = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
      sourceSut = navigationSut.topViewController as! MainTranslationControllerViewController
      sourceSut.translationManager = MockTranslationViewModel()
      sourceSut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
      sourceSut = nil
      navigationSut = nil
    }
  
  func testStateChanges() throws {
//  When
    sourceSut.translationManager.action = .didChooseLanguage(.en, "Testing")
//  Then
    delay(2){ [weak self] in
      guard let vc = try? XCTUnwrap(self?.navigationSut.topViewController as? TranslatedViewController) else {
        XCTFail()
        return
      }
      let displayedTranslatedText = vc.translatedText
      let displayedSourceText = vc.sourceText
      XCTAssertEqual(displayedTranslatedText, "This is a test")
      XCTAssertEqual(displayedSourceText, "Testing")
    }
  }
  
  func testResettingText(){
//    When
    sourceSut.textViewMain.text = "Text to delete"
    sourceSut.resetText()
//    Then
    let text = sourceSut.textViewMain.text
    XCTAssertEqual(text, "")
  }

}

class MockTranslationViewModel: TranslationManager{
  
  struct Service: TranslateServiceProvider{
    func translate(text: String, from: Language, to: Language) -> Observable<TranslatedResponse> {
      .just(TranslatedResponse(text: "This is a test"))
    }
  }
  
  init(){
    let initialState = TranslationBaseState(textTotranslate: "Ceci est un test",
                                            targetLanguage: .en,
                                            translatedText: "This is a test",
                                            translationError: nil)
    
    super.init(initialState: initialState,
               initialAction: .none,
               service: Service())
  }
}
