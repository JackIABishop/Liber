//
//  MoreInfoViewController.swift
//  Liber
//
//  Created by Jack Bishop on 10/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class will handle the MoreInfoViewController, so a user can click on a book entry and view more info about it.

import UIKit
import Firebase

class MoreInfoViewController: UIViewController {
  
  // Instance Variables
  var bookToView = Book()
  var buttonHidden: Bool?
  
  // Linking UI Elements
  @IBOutlet var titleText: UILabel!
  @IBOutlet var authorText: UILabel!
  @IBOutlet var isbn13Text: UILabel!
  @IBOutlet var isbn10Text: UILabel!
  @IBOutlet var publisherText: UILabel!
  @IBOutlet var publishedText: UILabel!
  @IBOutlet var deleteButton: UIButton!
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var loadingText: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.accessibilityIdentifier = "bookView" // Idenfitifier required to UI testing.
    
    // Setting up the view controller.
    titleText.text = bookToView.title
    authorText.text = bookToView.author[0]
    isbn13Text.text = bookToView.isbn_13
    isbn10Text.text = bookToView.isbn_10
    publisherText.text = bookToView.publisher
    publishedText.text = bookToView.published
    
    // Preventing the user from deleting a book that is not their own.
    deleteButton.isHidden = buttonHidden!
    
    downloadThumbnail()
  }
  
  func downloadThumbnail() {
    // Reset UIImageView to nil.
    thumbnailImageView.image = nil
    
    // Check if thumbnail available.
    if (bookToView.thumbnail?.absoluteString != "") {
      indeterminateLoad(displayText: "Loading Image", view: self.view)
      
      let session = URLSession(configuration: .default)
      
      let downloadPicTask = session.dataTask(with: bookToView.thumbnail!) { (data, response, error) in
        // The download has finished.
        if let err = error {
          print("Error downloading pic: \(err)")
        } else {
          // No errors found
          if let res = response as? HTTPURLResponse {
            print ("downloaded pic with response code: \(res.statusCode)")
            if let imageData = data {
              // Convert that data into an image and set it as the thumbnail.
              DispatchQueue.main.async {
                self.loadingText.text = ""
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
      hideHUD(view: self.view)
      downloadPicTask.resume()
    } else {
      loadingText.text = "Not Available"
      // Reset UIImageView to nil.
      thumbnailImageView.image = nil
    }
  }
  
  // MARK: - Book Deletion Handling
  @IBAction func deleteBookPressed(_ sender: Any) {
    // Open an action sheet to confirm the deletion of the book entry.
    let deleteMenu = UIAlertController(title: "Warning", message: "Deleting your account is a destructive action, this book entry will be deleted.", preferredStyle: UIAlertController.Style.actionSheet)
    
    // Options
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
    
    let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive) { (alert) in
      indeterminateLoad(displayText: "Deleting book", view: self.view)
      
      deleteBook(bookToDelete: self.bookToView, completion: { (_) in
        self.performSegue(withIdentifier: "goToTabView", sender: self)
        hideHUD(view: self.view)
      })
    }
    
    // Add the options to the menu.
    deleteMenu.addAction(cancelAction)
    deleteMenu.addAction(confirmAction)
    
    self.present(deleteMenu, animated: true, completion: nil)
  }
  
  @IBAction func backButtonPressed(_ sender: Any) {
    thumbnailImageView.image = nil
    performSegue(withIdentifier: "goToTabView", sender: self)
  }
}

