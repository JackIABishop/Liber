//
//  ManualAddViewController.swift
//  Liber
//
//  Created by Jack Bishop on 30/01/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  This class will handle the controller to manually add a book entry. 

import UIKit
import Firebase

class ManualAddViewController: UIViewController {
  
  // Linking UI Elements
  @IBOutlet var titleText: UITextField!
  @IBOutlet var authorText: UITextField!
  @IBOutlet var isbn13Text: UITextField!
  @IBOutlet var isbn10Text: UITextField!
  @IBOutlet var publisherText: UITextField!
  @IBOutlet var publishedText: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func confirmButtonPressed(_ sender: Any) {
    // Check if the user has entered a book title.
    if titleText.text?.count != 0 && authorText.text?.count != 0 {
      // Save the book in user's database.
      indeterminateLoad(displayText: "Saving Book", view: self.view)
      
      let bookDictionary = ["Book Title": titleText.text!,
                            "Author": authorText.text!,
                            "ISBN-13": isbn13Text.text!,
                            "ISBN-10": isbn10Text.text!,
                            "Publisher": publisherText.text!,
                            "Published": publishedText.text!]
      
      addBook(bookToAdd: bookDictionary) { (_) in
        self.performSegue(withIdentifier: "goToTabView", sender: self)
        hideHUD(view: self.view)
      }
    } else {
      // Print an error message to the user.
      let errorAlert = UIAlertController(title: "Uh-oh", message: "A book title & author is required", preferredStyle: .alert)
      errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(errorAlert, animated: true, completion: nil)
    }
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    performSegue(withIdentifier: "goToTabView", sender: self)
  }
}

