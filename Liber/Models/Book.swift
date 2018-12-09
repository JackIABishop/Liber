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
    var author = [String]()
    var isbn_13 : String = ""
    var isbn_10 : String = ""
    var publisher : String = ""
    var published : String = ""
    var thumbnail = URL(string: "")
    //var price : String = ""
    //var location : String = ""
    
    func resetClassData() {
        title = ""
        author.removeAll()
        isbn_13 = ""
        isbn_10 = ""
        publisher = ""
        published = ""
        thumbnail = URL(string: "")
        //price = ""
        //location = ""
    }
    
    let bookElements : Int = 7
}
