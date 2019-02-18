//
//  OrganisationViewController.swift
//  Liber
//
//  Created by Jack Bishop on 12/02/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//

import UIKit
import Firebase

class OrganisationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Instance variables.
    var numberOfOrganisations: Int = 1
    var subscribedOrganisations = [Organisation]()
    
    // Linking UI Elements.
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            indeterminateLoad(displayText: "Loading Organisations", view: self.view)
            // Load subscribed organisations.
            self.retrieveOrganisations()
        }
        
        hideHUD(view: self.view)
    }
    
    // Save the organisation data in the users DB.
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToTabView", sender: self)
    }
    
    // Load organisation data.
    func retrieveOrganisations() {
        
        indeterminateLoad(displayText: "Loading Organisation", view: self.view)
        
        // Read from the database.
        let subscribedDB = Database.database().reference().child("Users").child(organisationCode).child("Subscribed Organisations")
        
        // Go through each item add them to the subscribed DB.
        subscribedDB.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChildren() {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    let newOrganisation = Organisation(orgCodeToAdd: (snap.value as? String)!)
                    
                    //newOrganisation.orgCode = (snap.value as? String)!
                    
                    // Add the code to the subscribed organisations.
                    self.subscribedOrganisations.append(newOrganisation)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        hideHUD(view: self.view)
    }
    
    //MARK:- TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribedOrganisations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get organisation name.
        indeterminateLoad(displayText: "Hold on...", view: self.view)
        
        var orgName = ""
        let orgCode = subscribedOrganisations[indexPath.row].orgCode
        
        _ = Database.database().reference().child("Users").child(orgCode).child("Name").observe(.value) { (snapshot) in
            if let value = snapshot.value as? String {
                orgName = value
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            // Select a row shows the organisation details, then off OK or Delete options.
            let viewOrgData = UIAlertController(title: "Organisation Details", message: "Name: \(orgName), UID: \(orgCode)", preferredStyle: UIAlertController.Style.alert)
            
            // Add action buttons.
            viewOrgData.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert) in
                // Double ask the user if they want to delete this organisation.
                let confirmDeleteAlert = UIAlertController(title: "Are you sure?", message: "Delete this organisation: \(orgName)", preferredStyle: .alert)
                
                confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                confirmDeleteAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (delete) in
                    // Delete organisation
                    print("Deleting organisation")
                    
                    let orgDB = Database.database().reference().child("Users").child(organisationCode).child("Subscribed Organisations")
                    
                    // Go through users subscribed organisations and delete the matched UID.
                    orgDB.observeSingleEvent(of: .value) { (orgSnapshot) in
                        if orgSnapshot.hasChildren() {
                            for child in orgSnapshot.children {
                                let snap = child as! DataSnapshot
                                
                                // Found a match
                                if snap.value as? String == orgCode {
                                    // If that match is users org, do not delete
                                    if snap.value as? String == organisationCode {
                                        // Show UIAlert of error.
                                        let errorAlert = UIAlertController(title: "Error", message: "You cannot delete your own bookcase", preferredStyle: .alert)
                                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                                        self.present(errorAlert, animated: true, completion: nil)
                                    } else {
                                        // Delete organisation
                                        snap.ref.removeValue()
                                        self.subscribedOrganisations.remove(at: indexPath.row)
                                        
                                        // Show UIAlert of confirmation.
                                        let errorAlert = UIAlertController(title: "Success", message: "Organisation deleted.", preferredStyle: .alert)
                                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                                        self.present(errorAlert, animated: true, completion: nil)
                                        
                                        //NOTE:- Not Working
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                        
                                        return
                                    }
                                }
                            }
                        }
                    }
                }))
                
                self.present(confirmDeleteAlert, animated: true, completion: nil)
            }))
            viewOrgData.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(viewOrgData, animated: true, completion: nil)
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        hideHUD(view: self.view)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "organisationItemCell")
        
        if (!subscribedOrganisations.isEmpty) {
            // List out organisations.
            let orgCode = subscribedOrganisations[indexPath.row].orgCode
            
            _ = Database.database().reference().child("Users").child(orgCode).child("Name").observe(.value) { (snapshot) in
                if let value = snapshot.value as? String {
                    cell?.textLabel?.text = value
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {}
            
            
        } else {
            //TODO: - Print no content found. https://stackoverflow.com/questions/28532926/if-no-table-view-results-display-no-results-on-screen
            cell?.textLabel?.text = "no content found"
        }
        
        
        return cell!
    }
    
    // Allow the user to add an organisation.
    @IBAction func addButtonPressed(_ sender: Any) {
        var matchFound: Bool = false
        var dontAdd: Bool = false
        
        let orgDB = Database.database().reference().child("Users").child(organisationCode).child("Subscribed Organisations")
        
        // Show an UIAlert that will prompt the user to add an organisation code and store in subscribed databases.
        let addOrganisationAlert = UIAlertController(title: "Add Organisation", message: "Add the organisation code that you wish to add", preferredStyle: .alert)
        
        addOrganisationAlert.addTextField { (orgToAdd) in
            orgToAdd.placeholder = "Organisation Code"
        }
        
        addOrganisationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        addOrganisationAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (alert) in
            let orgNum = addOrganisationAlert.textFields![0] // Force unwrap is safe because I know it exists.
            
            // Check if the organisation code is valid.
            let identifierDB = Database.database().reference().child("Identifiers")
            identifierDB.observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    // Check if OrgCode is valid.
                    if snap.value! as? String == orgNum.text {
                        
                        // Check if user has already saved the organisation in their database.
                        orgDB.observeSingleEvent(of: .value, with: { (orgsnapshot) in
                            for entry in orgsnapshot.children.allObjects as! [DataSnapshot] {
                                print(entry.value!)
                                
                                if entry.value! as? String == orgNum.text {
                                    // If already in DB
                                    dontAdd = true
                                    let errorAlert = UIAlertController(title: "Error", message: "Already subscribed to this organisation.", preferredStyle: .alert)
                                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(errorAlert, animated: true, completion: nil)
                                } else {
                                    matchFound = true
                                }
                            }
                        })
                    }
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                if matchFound != true {
                    print("Code not valid")
                    // Show UIAlert of code not being valid.
                    let errorAlert = UIAlertController(title: "Error", message: "Code not found in UID database", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(errorAlert, animated: true, completion: nil)
                } else {
                    if dontAdd == false {
                        // Save the organisation in the users subscribed organisations.
                        orgDB.childByAutoId().setValue(orgNum.text) {
                            (error, reference) in
                            if error != nil {
                                print(error as Any)
                            } else {
                                // Save data in local data source.
                                let orgToAdd = Organisation(orgCodeToAdd: orgNum.text!)
                                self.subscribedOrganisations.append(orgToAdd)
                                
                                print("Organisation saved successfully!")
                                matchFound = true
                                
                                DispatchQueue.main.async { self.tableView.reloadData() }
                                
                                // Show UIAlert of code being valid.
                                let errorAlert = UIAlertController(title: "Success", message: "Organisation saved successfully!", preferredStyle: .alert)
                                errorAlert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                    self.tableView.reloadData()
                                })))
                                self.present(errorAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }))
        
        self.present(addOrganisationAlert, animated: true, completion: nil)
    }
    
}
