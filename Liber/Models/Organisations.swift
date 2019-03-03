//
//  Organisations.swift
//  Liber
//
//  Created by Jack Bishop on 11/02/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  Handles the data for the organisation structures.

import Foundation

struct Organisation {
  var orgCode: String = ""
  var books = [Book]()
  var orgName: String = ""
  
  init(orgCodeToAdd: String) {
    orgCode = orgCodeToAdd
  }
  
  init(orgCodeToAdd: String, booksToAdd: [Book]) {
    orgCode = orgCodeToAdd
    books = booksToAdd
  }
}

