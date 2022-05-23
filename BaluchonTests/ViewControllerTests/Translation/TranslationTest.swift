//
//  TranslationTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 06/03/2022.
//

import XCTest
import RxSwift
import RxRelay
@testable import Baluchon

class MainTranslationViewController: XCTestCase {
  var sut: MainTranslationControllerViewController!
  
    override func setUpWithError() throws {
      try super.setUpWithError()
      app = XCUIApplication()
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
      sut = navigationController.topViewController as! MainTranslationControllerViewController
      sut.translationViewModel = TranslationViewModelMock()
      sut.loadViewIfNeeded()
      
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testStateChanges(){
//      When
      
//    Then
      let translatedText = sut.translationViewModel.getCurrentState().translatedText
       XCTAssertEqual(translatedText, "This is a test")
  }
}


class TranslationViewModelMock: TranslationViewModel{
  
  class Service: TranslateServiceProvider{
    func translate(text: String, from: Language, to: Language) -> Observable<TranslatedResponse> {
      let translatedResponse = TranslatedResponse(text: "This is a test")
      return .just(translatedResponse)
    }
  }
  let initialState = TranslationBaseState()
  init(){
    super.init(initialState: initialState,
               initialAction: .none,
               service: Service())
  }
}
