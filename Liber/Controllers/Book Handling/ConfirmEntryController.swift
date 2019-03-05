//
//  ConfirmEntryController.swift
//  Liber
//
//  Created by Jack Bishop on 08/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class will handle the data that is recieved from the Google Books API call after a barcode scan has been triggered.

import UIKit
import Firebase

class ConfirmEntryController: UIViewController {
  
  // Linking UI Elements
  @IBOutlet var titleText: UITextField!
  @IBOutlet var authorText: UITextField!
  @IBOutlet var isbn13Text: UITextField!
  @IBOutlet var isbn10Text: UITextField!
  @IBOutlet var publisherText: UITextField!
  @IBOutlet var publishedText: UITextField!
  @IBOutlet var thumbnailImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleText.text = currentBookData.title
    
    var counter : Int = 1
    for author in currentBookData.author {
      authorText.text?.append(author)
      if (counter != currentBookData.author.count) {
        authorText.text?.append(", ")
      }
      counter = counter + 1
    }
    
    isbn13Text.text = currentBookData.isbn_13
    isbn10Text.text = currentBookData.isbn_10
    publisherText.text = currentBookData.publisher
    publishedText.text = currentBookData.published
    
    // Check if thumbnail available.
    if (currentBookData.thumbnail != nil) {
      
      let session = URLSession(configuration: .default)
      
      let downloadPicTask = session.dataTask(with: currentBookData.thumbnail!) { (data, response, error) in
        // The download has finished.
        if let err = error {
          print("Error downloading pic: \(err)")
        } else {
          // No errors found.
          if let res = response as? HTTPURLResponse {
            print ("downloaded pic with response code\(res.statusCode)")
            if let imageData = data {
              // Convert that data into an image and set it as the thumbnail.
              DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: imageData)
              }
              
            } else {
              print ("Couldn't get image: image is nil")
            }
          } else {
            print("Couldn't get response code")
          }
        }
      }
      downloadPicTask.resume()
    }
  }
  
  //MARK: - Button press handling
  @IBAction func cancelButtonPressed(_ sender: Any) {
    // Cancel action and return to add screen.
    performSegue(withIdentifier: "goToTabView", sender: self)
  }
  
  @IBAction func confirmButtonPressed(_ sender: Any) {
    // Save the book in user's database
    indeterminateLoad(displayText: "Saving Book", view: self.view)
    
    let bookDictionary = ["Book Title": titleText.text!,
                          "Author": authorText.text!,
                          "ISBN-13": isbn13Text.text!,
                          "ISBN-10": isbn10Text.text!,
                          "Publisher": publisherText.text!,
                          "Published": publishedText.text!,
                          "Thumbnail": currentBookData.thumbnail!.absoluteString]
    
    addBook(bookToAdd: bookDictionary) { (_) in
      self.performSegue(withIdentifier: "goToTabView", sender: self)
      hideHUD(view: self.view)
    }
  }
}

