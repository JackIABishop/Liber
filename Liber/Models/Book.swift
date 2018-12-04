//
//  Book.swift
//  Liber
//
//  Created by Jack Bishop on 04/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//

import Foundation

// Handles the data for a book.
class Book {
    var title : String = ""
    var author : String = ""
    var isbn_13 : Int = 0
    var isbn_10 : Int = 0
    var edition : Int = 0
    var binding : String = ""
    var publisher : String = ""
    var published = Date()
    var price : Double = 0.0
    var location : String = ""
}
