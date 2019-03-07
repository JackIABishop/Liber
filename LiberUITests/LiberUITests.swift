//
//  LiberUITests.swift
//  LiberUITests
//
//  Created by Jack Bishop on 03/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//

import XCTest

class LiberUITests: XCTestCase {
  
  override func setUp() {
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
  }
  
  // UI test to go through the elements   to login via the test account
  func testLogin() {
    let app = XCUIApplication()
    app.buttons["Log In"].tap()
    app.textFields["Email"].tap()
    app.textFields["Email"].typeText("test@test.com")
    app.secureTextFields["Password"].tap()
    app.secureTextFields["Password"].typeText("password")
    app.buttons["Login"].tap()
    
    sleep(5) // Wait for the server call to be made.
    
    XCTAssertTrue(app.isDisplayingBookcase)
  }
}

extension XCUIApplication {
  var isDisplayingBookcase: Bool {
    return otherElements["bookcaseView"].exists
  }
}

