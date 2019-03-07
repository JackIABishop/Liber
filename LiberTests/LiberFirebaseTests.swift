//
//  LiberFirebaseTests.swift
//  LiberTests
//
//  Created by Jack Bishop on 04/03/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  Test cases for the database driven functions. 

import XCTest
@testable import Liber
import FirebaseAuth

class LiberFirebaseTests: XCTestCase {
  
  var testOrganisationCode: String = "53C572EA-FE0E-4807-AF6E-240826AA6B96" // Org code for Test account.
  var testBook = Book()
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // Filling the test book with data.
    testBook.title = "Test Title"
    testBook.author[0] = "Test Author"
    testBook.isbn_13 = "1234567890123"
    testBook.isbn_10 = "1234567890"
    testBook.publisher = "Test Publisher"
    testBook.published = "Test Date"
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  //MARK:- Bookcase Management Tests
  func testAddBook() {
    // Creating test books.
    let bookDictionary = ["Book Title": "Test Add Title",
                          "Author": "Test Add Author",
                          "ISBN-13": "Test Add ISBN",
                          "ISBN-10": "Test Add ISBN",
                          "Publisher": "Test Add Publisher",
                          "Published": "Test Add Published"]
    
    let bookToAdd = Book()
    bookToAdd.title = "Test Add Title"
    bookToAdd.author[0] = "Test Add Author"
    bookToAdd.isbn_13 = "Test Add ISBN"
    bookToAdd.isbn_10 = "Test Add ISBN"
    bookToAdd.publisher = "Test Add Publisher"
    bookToAdd.published = "Test Add Published"
    
    // Make sure the book is not currently in the database.
    checkBookInOrganisation(bookToCheck: bookToAdd, orgCodeToCheck: testOrganisationCode) { (result) in
      if !result {
        // Add a test book to the database.
        addBook(bookToAdd: bookDictionary) { (_) in
          // Check if the book is in the database.
          checkBookInOrganisation(bookToCheck: bookToAdd, orgCodeToCheck: self.testOrganisationCode, completion: { (result) in
            XCTAssertTrue(result) // This test will pass if the book is in the database.
          })
        }
      } else {
        print("error")
        XCTFail()
      }
    }
    
  }
  
  func testDeleteBook() {
    // This testDeleteBook() will remove the book which has been added by the testAddBook() function.
    
    // Check that the book is in the database.
    checkBookInOrganisation(bookToCheck: self.testBook, orgCodeToCheck: self.testOrganisationCode) { (_) in
      // Using the deleteBook function being tested.
      deleteBook(bookToDelete: self.testBook) { (_) in
        // Check that the book is not in the database, if so, pass the test.
        checkBookInOrganisation(bookToCheck: self.testBook, orgCodeToCheck: self.testOrganisationCode, completion: { (result) in
          XCTAssertFalse(result) // Book is not in the database.
        })
      }
    }
  }
 
  
  //MARK:- Organisation Management Tests
  
  func testDeleteAccount() {
    //TODO:- Test removing the test account
  }
  
  func testRecieveBooks() {
    
  }
  
  
}

