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
    var filteredBooks = [Book]()

    // Linking UI Elements
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            indeterminateLoad(displayText: "Loading Bookcase", view: self.view)
            self.retrieveBooks()
            //self.filteredData = self.usersBooks
        }
        
        searchBar.delegate = self
        
        hideHUD(view: self.view)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        // Present action controller asking user method of book entry.
        let optionMenu = UIAlertController(title: "Book Entry", message: "How would you like to add your book?", preferredStyle: UIAlertController.Style.actionSheet)
        
        // Creation options.
        let manualEntryAction = UIAlertAction(title: "Manual Entry", style: UIAlertAction.Style.default) { (alert) in
            self.performSegue(withIdentifier: "goToManualEntry", sender: self)
        }
        
        let barcodeScanAction = UIAlertAction(title: "Barcode Scan", style: UIAlertAction.Style.default) { (alert) in
            self.performSegue(withIdentifier: "goToBarcodeEntry", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        // Adding the actions to the menu.
        optionMenu.addAction(manualEntryAction)
        optionMenu.addAction(barcodeScanAction)
        optionMenu.addAction(cancelAction)
        
        // Present the menu to the screen.
        self.present(optionMenu, animated: true, completion: nil)
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
                    //print(snap)
                    
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
                    self.filteredBooks.append(newBook)
                    
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
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookItemCell")
        
        if (!filteredBooks.isEmpty) {
            // List out books.
            cell?.textLabel?.text = filteredBooks[indexPath.row].title
        } else {
            //TODO: - Print no content found. https://stackoverflow.com/questions/28532926/if-no-table-view-results-display-no-results-on-screen
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set selected cell as the chosen book to view more information on.
        selectedBook = filteredBooks[indexPath.row]
        
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
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Reset the books
        filteredBooks = usersBooks
        
        if searchBar.text?.count != 0 {
            filteredBooks = filteredBooks.filter({ (item) -> Bool in
                item.title.contains(find: searchText)
            })
        }
        
        tableView.reloadData()
    }
    
    
    // Enable the cancel button on the search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    // When Search Bar Cancel button is pressed.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// Extension to filter out the books.
extension String {
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
}

