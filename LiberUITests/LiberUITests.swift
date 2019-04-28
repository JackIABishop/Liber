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
  
  
  
  // Open a book and check if exepected behaviour is true.
  func testAddBook() {
    let app = XCUIApplication()
    
    // Login
    app.buttons["Log In"].tap()
    app.textFields["Email"].tap()
    app.textFields["Email"].typeText("test@test.com")
    app.secureTextFields["Password"].tap()
    app.secureTextFields["Password"].typeText("password")
    app.buttons["Login"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    app/*@START_MENU_TOKEN@*/.otherElements["bookcaseView"].navigationBars["Bookcase"]/*[[".otherElements[\"bookcaseView\"].navigationBars[\"Bookcase\"]",".navigationBars[\"Bookcase\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.buttons["Add"].tap()
    app.sheets["Book Entry"].buttons["Manual Entry"].tap()
    
    // Add a book
    let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 2).children(matching: .other).element
    element.children(matching: .textField).element(boundBy: 0).tap()
    app.typeText("Test Title")
    element.children(matching: .textField).element(boundBy: 1).tap()
    app.typeText("Test Author")
    element.children(matching: .textField).element(boundBy: 2).tap()
    app.typeText("Test ISBN13")
    element.children(matching: .textField).element(boundBy: 3).tap()
    app.typeText("Test ISBN10")
    element.children(matching: .textField).element(boundBy: 4).tap()
    app.typeText("Test Publisher")
    element.children(matching: .textField).element(boundBy: 5).tap()
    app.typeText("Test Published")
    app.navigationBars["Manual Add"].buttons["Confirm"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    XCTAssertTrue(app.isDisplayingBookcase) // Testing Case
  }
  
  // Close a book and check expected outcome.
  func testDeleteBook() {
    let app = XCUIApplication()
    
    // Login
    app.buttons["Log In"].tap()
    app.textFields["Email"].tap()
    app.textFields["Email"].typeText("test@test.com")
    app.secureTextFields["Password"].tap()
    app.secureTextFields["Password"].typeText("password")
    app.buttons["Login"].tap()

    sleep(3) // Wait for the server call to be made.
    app/*@START_MENU_TOKEN@*/.tables/*[[".otherElements[\"bookcaseView\"].tables",".tables"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .cell).element(boundBy: 0).staticTexts["Test Title"].tap()
    app/*@START_MENU_TOKEN@*/.buttons["Delete Book"]/*[[".otherElements[\"bookView\"].buttons[\"Delete Book\"]",".buttons[\"Delete Book\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    app.sheets["Warning"].buttons["Confirm"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    XCTAssertTrue(app.isDisplayingBookcase) // Testing Case
  }
  
  // UI Test to go to the account view and open the organisation screen.
  func testViewOrganisations() {
    let app = XCUIApplication()
    
    // Login
    app.buttons["Log In"].tap()
    app.textFields["Email"].tap()
    app.textFields["Email"].typeText("test@test.com")
    app.secureTextFields["Password"].tap()
    app.secureTextFields["Password"].typeText("password")
    app.buttons["Login"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    app.tabBars.buttons["Account"].tap()
    app/*@START_MENU_TOKEN@*/.buttons["View Organisations"]/*[[".otherElements[\"accountView\"].buttons[\"View Organisations\"]",".buttons[\"View Organisations\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    
    sleep(3) // Wait for the server call to be made.
    
    XCTAssertTrue(app.isDisplayingOrganisation) // Testing Case
  }
  
  // Test to add an example organisation
  func testAddOrganisation() {
    let app = XCUIApplication()
    
    // Login
    app.buttons["Log In"].tap()
    app.textFields["Email"].tap()
    app.textFields["Email"].typeText("test@test.com")
    app.secureTextFields["Password"].tap()
    app.secureTextFields["Password"].typeText("password")
    app.buttons["Login"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    app.tabBars.buttons["Account"].tap()
    app/*@START_MENU_TOKEN@*/.buttons["View Organisations"]/*[[".otherElements[\"accountView\"].buttons[\"View Organisations\"]",".buttons[\"View Organisations\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    app/*@START_MENU_TOKEN@*/.navigationBars["Organisations"]/*[[".otherElements[\"organisationView\"].navigationBars[\"Organisations\"]",".navigationBars[\"Organisations\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Add"].tap()
    
    sleep(1)
    
    let addOrganisationAlert = XCUIApplication().alerts["Add Organisation"]
    let organisationCodeTextField = addOrganisationAlert.collectionViews.textFields["Organisation Code"]
    organisationCodeTextField.tap()
    
    // Added my own organisation to the test account
    organisationCodeTextField.typeText("24129990-C9C4-44A0-9737-7DD9D1B67A74")
    
    addOrganisationAlert.buttons["Confirm"].tap()
    app.alerts["Success"].buttons["OK"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    XCTAssertTrue(app.isDisplayingOrganisation) // Testing Case
  }
  
  // UI Test to delete the previously added organisation.
  func testDeleteOrganisation() {
    let app = XCUIApplication()
    
    // Login
    app.buttons["Log In"].tap()
    app.textFields["Email"].tap()
    app.textFields["Email"].typeText("test@test.com")
    app.secureTextFields["Password"].tap()
    app.secureTextFields["Password"].typeText("password")
    app.buttons["Login"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    app.tabBars.buttons["Account"].tap()
    app/*@START_MENU_TOKEN@*/.buttons["View Organisations"]/*[[".otherElements[\"accountView\"].buttons[\"View Organisations\"]",".buttons[\"View Organisations\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    
    sleep(1)
    
    
    app.tables.staticTexts["Jack"].tap()
    app.alerts["Organisation Details"].buttons["Delete"].tap()
    app.alerts["Are you sure?"].buttons["Confirm"].tap()
    app.alerts["Success"].buttons["OK"].tap()
    
    sleep(1)
    
    XCTAssertTrue(app.isDisplayingOrganisation) // Testing Case
  }
  
  // Test to logout
  func testLogout() {
    let app = XCUIApplication()
    
    //Login
    app.buttons["Log In"].tap()
    app.textFields["Email"].tap()
    app.textFields["Email"].typeText("test@test.com")
    app.secureTextFields["Password"].tap()
    app.secureTextFields["Password"].typeText("password")
    app.buttons["Login"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    print(app.buttons.debugDescription)
    
    app.tabBars.buttons["Account"].tap()
    
    app.navigationBars["Account"].buttons["Logout"].tap()
    
    sleep(3) // Wait for the server call to be made.
    
    XCTAssertTrue(app.isDisplayingLogin) // Testing Case
  }
}

// I created an extension to the testing application to easily check if the desired screens are currntly displayed.
extension XCUIApplication {
  var isDisplayingBookcase: Bool {
    return otherElements["bookcaseView"].exists
  }
  
  var isDisplayingLogin: Bool {
    return otherElements["loginView"].exists
  }
  
  var isDisplayingOrganisation: Bool {
    return otherElements["organisationView"].exists
  }
  
  var isDisplayingBookView: Bool {
    return otherElements["bookView"].exists
  }
}

