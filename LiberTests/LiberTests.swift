//
//  LiberTests.swift
//  LiberTests
//
//  Created by Jack Bishop on 03/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//

import XCTest
@testable import Liber

class LiberTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // Login a User?
    let registerParams = ["Name": "Test Account", "Email": "test@test.com", "Password": "password"]
    registerFirebaseUser(registerParameters: registerParams) { (result) in
      if result {
        // Success
      }
      else {
        //Error
      }
    }
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testBookClass() {
    // Creating a book object, filling it with data and testing the resetClassData function.
    let testBook: Book = Book()
    // Testing 3 different methods of holding data within the book class.
    testBook.title = "Test Title"
    testBook.author[0] = "Test Author"
    testBook.thumbnail = URL(string: "Test_URL")
    
    XCTAssertTrue(testBook.title.count > 0)
    XCTAssertTrue(testBook.author[0].count > 0)
    XCTAssertTrue((testBook.thumbnail?.absoluteString.count)! > 0)
    testBook.resetClassData()
    XCTAssertTrue(testBook.title.count == 0)
    XCTAssertTrue(testBook.author.count == 0)
    XCTAssertTrue(testBook.thumbnail == nil)
  }
  
  func testOrganisationClass() {
    // Testing the initialiser of the organisation struct.
    let testBook: Book = Book()
    let testOrganisation = Organisation(orgCodeToAdd: "12345", booksToAdd: [testBook])
    
    XCTAssertTrue(testOrganisation.orgCode.count > 0)
    XCTAssertTrue(testOrganisation.books.count > 0)
  }
  
  func testManualAddViewController() {
    
    
  }
  
  func textConfirmEntryViewController() {
    
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}


