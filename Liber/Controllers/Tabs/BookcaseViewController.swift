//
//  BookcaseViewController.swift
//  Liber
//
//  Created by Jack Bishop on 03/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class holds the logic for the Bookcase Tab View Controller. 

import UIKit
import Firebase
import SVProgressHUD

class BookcaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Instance Variables
    var numberOfBooksInUsersAccount : Int = 3 //NOTE: - This needs to change, very bad coding but currently does not set this before tableViews have been loaded.
    var usersBooks = [Book]()
    var databaseHandle : DatabaseHandle!
    let userEmail = Auth.auth().currentUser?.email!

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load user's bookcase data.
        SVProgressHUD.show()
        
        // Read data from the database
        let parsedEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
        
        let bookDatabase = Database.database().reference().child("Users").child(parsedEmail!)
        
        // Check if there is any data in the users account, if there is fill the data with the users books.
        bookDatabase.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChildren(){
                // Found data.
                self.numberOfBooksInUsersAccount = Int(snapshot.childrenCount)
                // For each book in users account
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    print(snap)
                    
                    // Store each book in usersBooks array
                    let newBook = Book()
                    
                    // Converting the data to Strings useable in the Book object.
                    let dataChange = snap.value as? [String:AnyObject]
                    let title = dataChange!["Book Title"]
                    let author = dataChange!["Author"]
                    let ISBN13 = dataChange!["ISBN-13"]
                    let ISBN10 = dataChange!["ISBN-10"]
                    let publisher = dataChange!["Publisher"]
                    let published = dataChange!["Published"]
                    newBook.title = title as! String
                    newBook.author[0] = author as! String
                    newBook.isbn_13 = ISBN13 as! String
                    newBook.isbn_10 = ISBN10 as! String
                    newBook.publisher = publisher as! String
                    newBook.published = published as! String
                    
                    // usersBook will now store all books the user has.
                    self.usersBooks.append(newBook)
                    
                }
            } else {
                // No data.
            }
        }
        
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfBooksInUsersAccount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookItemCell")
        
        if (!usersBooks.isEmpty) {
            // List out books.
            let book = usersBooks[indexPath.row]
            
            cell?.textLabel?.text = book.title
        } else {
            //TODO: - Print no content found.
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMoreInfo", sender: self)
        
        let selectedBook = usersBooks[indexPath.row]
        let destinationVC = MoreInfoViewController()
        destinationVC.bookToView = selectedBook
        
        performSegue(withIdentifier: "goToMoreInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MoreInfoViewController
        destinationVC.bookToView.title = "test"
    }
    
}

//MARK: - Search Bar Methods
extension BookcaseViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
    }
}



