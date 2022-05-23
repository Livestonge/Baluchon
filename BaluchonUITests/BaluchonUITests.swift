//
//  BaluchonUITests.swift
//  BaluchonUITests
//
//  Created by Awaleh Moussa Hassan on 17/01/2022.
//

import XCTest

class BaluchonUITests: XCTestCase {
  
  var app: XCUIApplication!
  
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
  
  func testSwichingCurrency() throws{
    
    let app = XCUIApplication()
    let eurStaticText = app.staticTexts["EUR"]
    eurStaticText.tap()
    
    let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0)
    element.tap()
    
    let usdStaticText = app.staticTexts["USD"]
    usdStaticText.tap()
    usdStaticText.tap()
    eurStaticText.tap()
    element.tap()
    eurStaticText.tap()
    
    
    

  }
}
