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

class BookcaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Instance Variables
    var usersBooks = [Book]()
    var databaseHandle : DatabaseHandle!
    let userEmail = getFirebaseUserEmail()
    var selectedBook = Book()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveBooks()
    }
    
    func retrieveBooks() {
        // Load user's bookcase data.
        indeterminateLoad(displayText: "Loading bookcase", view: self.view)
        
        // Read data from the database
        let parsedEmail = userEmail.replacingOccurrences(of: ".", with: ",")
        
        let bookDatabase = Database.database().reference().child("Users").child(parsedEmail)
        
        // Check if there is any data in the users account, if there is fill the data with the users books.
        bookDatabase.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChildren(){
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
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                // No data.
            }
        }
        
        hideHUD(view: self.view)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersBooks.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected cell as the chosen book to view more information on.
        selectedBook = usersBooks[indexPath.row]

        performSegue(withIdentifier: "goToMoreInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MoreInfoViewController
        {
            let destinationVC = segue.destination as? MoreInfoViewController
            
            destinationVC?.bookToView = selectedBook
        }
    }
}

//MARK: - Search Bar Methods
extension BookcaseViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
    }
}



