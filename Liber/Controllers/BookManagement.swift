//
//  BookManagement.swift
//  Liber
//
//  Created by Jack Bishop on 04/03/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  This file will hold the functions which will be used to handle books in the database.

import UIKit
import Firebase

// Function to be called when deleting a book from the database.
func deleteBook(bookToDelete: Book, completion: @escaping (Bool) -> Void) {
  // Delete the book passed in as a parameter.
  
  // Remove the book from the database.
  let bookDatabase = Database.database().reference().child("Users").child(organisationCode).child("Collection")
  
  // Go through users database and remove the matched book.
  bookDatabase.observeSingleEvent(of: .value) { (snapshot) in
    if snapshot.hasChildren() {
      for child in snapshot.children {
        let snap = child as! DataSnapshot
        
        let dataChange = snap.value as? [String:AnyObject]
        
        let title = dataChange!["Book Title"]
        let author = dataChange!["Author"]
        
        if title as! String == bookToDelete.title &&
          author as! String == bookToDelete.author[0] {
          // When found a match, delete book.
          print("Deleting book")
          snap.ref.removeValue()
          
          completion(true)
        }
      }
    }
  }
}

// Function to add a book to the database, in the form of a Dictionary type.
func addBook(bookToAdd: [String : String], completion: @escaping (Bool) -> Void) {
  // Set each text field in the database.
  let bookDatabase = Database.database().reference().child("Users").child(organisationCode).child("Collection")
  
  bookDatabase.childByAutoId().setValue(bookToAdd) {
    (error, reference) in
    if error != nil {
      print(error as Any)
      completion(false)
    } else {
      print("Book saved successfully!")
      completion(true)
    }
  }
}

