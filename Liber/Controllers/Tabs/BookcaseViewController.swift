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
    var usersBooks = [Book]() // Store the users books.
    var subscribedOrganisations = [Organisation]() // Store the subscribed book data in here.
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
            //indeterminateLoad(displayText: "Loading Bookcase", view: self.view)
            self.retrieveSections()
            
            //TODO:- Get names
            
        }
        
        searchBar.delegate = self
        
        //hideHUD(view: self.view)
    }
    
    func retrieveSections() {
        // Read from the database.
        let subscribedDB = Database.database().reference().child("Users").child(organisationCode).child("Subscribed Organisations")
        
        // Go through each item add them to the subscribed DB.
        subscribedDB.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChildren() {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    let tempOrgNum: String = (snap.value as? String)! // Force-unwrap is safe here.
                    
                    let newOrganisation = Organisation(orgCodeToAdd: tempOrgNum)
                    
                    // Add the code to the subscribed organisations.
                    self.subscribedOrganisations.append(newOrganisation)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            // Look through users subscribed sections and retrieve their data.
            for (index, org) in self.subscribedOrganisations.enumerated() {
                self.retrieveBooks(orgCode: org.orgCode, index: index)
            }
            
            // Get the names for each organisation section.
            for (index, org) in self.subscribedOrganisations.enumerated() {
                self.retrieveOrgNames(orgCode: org.orgCode) { (orgName) in
                    self.subscribedOrganisations[index].orgName = orgName
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func retrieveOrgNames(orgCode: String, completion: @escaping (String) -> Void) {
        _ = Database.database().reference().child("Users").child(orgCode).child("Name").observe(.value) { (snapshot) in
            if let value = snapshot.value as? String {
                print(value)
                completion(value)
            }
        }
        
    }
    
    func retrieveBooks(orgCode : String, index: Int) {
    //func retrieveBooks(orgCode : String) {
        // Load user's bookcase data.
        indeterminateLoad(displayText: "Loading bookcase", view: self.view)
        
        // Read data from the database
        let bookDatabase = Database.database().reference().child("Users").child(orgCode).child("Collection")
        
        // Check if there is any data in the users account, if there is fill the data with the users books.
        bookDatabase.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChildren(){
                // For each book in users account
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
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
                
                    self.subscribedOrganisations[index].books.append(newBook)
                    
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
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Generate rows for each organisation section.
        return subscribedOrganisations[section].books.count
    }
    
    // Create the section headers for the bookcases.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = " \(subscribedOrganisations[section].orgName)'s Bookcase"
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return number for the amount of subscribed bookcases.
        return subscribedOrganisations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookItemCell")
        
        if (!filteredBooks.isEmpty) {
            // List out books.
            //cell?.textLabel?.text = filteredBooks[indexPath.row].title
            cell?.textLabel?.text = subscribedOrganisations[indexPath.section].books[indexPath.row].title
        } else {
            //TODO: - Print no content found. https://stackoverflow.com/questions/28532926/if-no-table-view-results-display-no-results-on-screen
            cell?.textLabel?.text = "no content found"
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

