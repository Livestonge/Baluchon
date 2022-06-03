//
//  ViewControllerTest.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 06/03/2022.
//

import XCTest
import RxSwift
import UIKit
@testable import Baluchon

class ViewControllerTest: XCTestCase {
  var sut: ViewController!
  
  override func setUpWithError() throws {
      try super.setUpWithError()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    sut = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    sut.currencyManager = CurrencyMock()
    sut.loadViewIfNeeded()
  }

  override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
  }
  
  func testinitialValue() {
//    When
    sut.userInputTextField.text = "100"
//  Then
    delay(2){ [weak self] in
      let usdValue = self?.sut.convertedValue.text
      XCTAssertEqual(usdValue, "200")
    }
    
  }
  
  func testSwitchBaseCurrency(){
//    When
    let gesture = sut.tapGestureOnSwitchView!
    sut.didTapOnSwitchView(gesture)
//    Then
    delay(2){ [weak self] in
      let baseCurrency = self?.sut.currencyManager.getCurrentState().baseCurrency.rawValue
      XCTAssertEqual(baseCurrency, "USD")
    }
    
  }

}
