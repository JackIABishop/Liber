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
    
    // Linking UI Elements
    @IBOutlet var titleText: UILabel!
    @IBOutlet var authorText: UILabel!
    @IBOutlet var isbn13Text: UILabel!
    @IBOutlet var isbn10Text: UILabel!
    @IBOutlet var publisherText: UILabel!
    @IBOutlet var publishedText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up the view controller.
        titleText.text = bookToView.title
        authorText.text = bookToView.author[0]
        isbn13Text.text = bookToView.isbn_13
        isbn10Text.text = bookToView.isbn_10
        publisherText.text = bookToView.publisher
        publishedText.text = bookToView.published
    }
    
    //MARK: - Book Deletion Handling
    @IBAction func deleteBookPressed(_ sender: Any) {
        // Open an action sheet to confirm the deletion of the book entry.
        let deleteMenu = UIAlertController(title: "Warning", message: "Deleting your account is a destructive action, this book entry will be deleted.", preferredStyle: UIAlertController.Style.actionSheet)
        
        // Options.
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive) { (alert) in
            self.deleteBook()
        }
        
        // Add the options to the menu.
        deleteMenu.addAction(cancelAction)
        deleteMenu.addAction(confirmAction)
        
        self.present(deleteMenu, animated: true, completion: nil)
    }
    
    func deleteBook() {
        // Delete the selected book.
        indeterminateLoad(displayText: "Deleting book", view: self.view)
        
        // Remove the book from the database.
        let bookDatabase = Database.database().reference().child("Users").child(organisationCode).child("Collection")
        
        // Go through users database and remove the matched book.
        bookDatabase.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChildren(){
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    let dataChange = snap.value as? [String:AnyObject]
                    
                    let title = dataChange!["Book Title"]
                    let author = dataChange!["Author"]
                    
                    if title as! String == self.bookToView.title &&
                        author as! String == self.bookToView.author[0] {
                        // When found a match, delete book.
                        print("Deleting book")
                        snap.ref.removeValue()
                    }
                }
            }
        }
        
        performSegue(withIdentifier: "goToTabView", sender: self)
        hideHUD(view: self.view)
    }
}
