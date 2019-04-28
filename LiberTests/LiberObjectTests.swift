//
//  LiberObjectTests.swift
//  LiberTests
//
//  Created by Jack Bishop on 04/03/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  Test cases for the objects that do not require the use of the database.

import XCTest
@testable import Liber

class LiberObjectTests: XCTestCase {
  
  func testBookClass() {
    // Creating a book object, filling it with data and testing the resetClassData function.
    let testBook: Book = Book()
    // Testing 3 different methods of holding data within the book class.
    testBook.title = "Test Title"
    testBook.author[0] = "Test Author"
    testBook.thumbnail = URL(string: "Test_URL")
    
    XCTAssertTrue(testBook.title == "Test Title")
    XCTAssertTrue(testBook.author[0] == "Test Author")
    XCTAssertTrue((testBook.thumbnail?.absoluteString)! == "Test_URL")
    testBook.resetClassData() // Check to see if the data is properly reset.
    XCTAssertTrue(testBook.title == "")
    XCTAssertTrue(testBook.author.count == 0)
    XCTAssertTrue(testBook.thumbnail == nil)
  }
  
  func testOrganisationClass() {
    // Testing the initialiser of the organisation struct.
    let testBook: Book = Book()
    testBook.title = "Test Title"
    let testOrganisation = Organisation(orgCodeToAdd: "12345", booksToAdd: [testBook])
    
    XCTAssertTrue(testOrganisation.orgCode == "12345")
    XCTAssertTrue(testOrganisation.books[0].title == testBook.title)
  }
}

