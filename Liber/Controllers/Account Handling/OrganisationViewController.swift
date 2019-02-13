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

        // Load subscribed organisations.
        retrieveOrganisations()
        
        // Adding dummy data.
        var org1 = Organisation()
        org1.orgCode = "test1"
        var org2 = Organisation()
        org2.orgCode = "test2"
        var realOrg = Organisation()
        realOrg.orgCode = "953F5245-BBC0-453B-9421-00297F32253D"
        
        subscribedOrganisations.append(realOrg)
        subscribedOrganisations.append(org1)
        subscribedOrganisations.append(org2)
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
                   print(snap.value!)

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
                                
                                print("Organisation saved successfully!")
                                matchFound = true
                                
                                // Show UIAlert of code being valid.
                                let errorAlert = UIAlertController(title: "Success", message: "Organisation saved successfully!", preferredStyle: .alert)
                                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(errorAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
        }))
        
        self.present(addOrganisationAlert, animated: true, completion: nil)
    }
    
    // Save the organisation data in the users DB.
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
        performSegue(withIdentifier: "goToTabView", sender: self)
    }
    
    // Load organisation data.
    func retrieveOrganisations() {
        
    }
    
    //MARK:- TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribedOrganisations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "organisationItemCell")
        
        if (!subscribedOrganisations.isEmpty) {
            // List out organisations.
            cell?.textLabel?.text = subscribedOrganisations[indexPath.row].orgCode
            //TODO:- List out organisation's name.
        } else {
            //TODO: - Print no content found. https://stackoverflow.com/questions/28532926/if-no-table-view-results-display-no-results-on-screen
            cell?.textLabel?.text = "no content found"
        }
        
        return cell!
    }
    
}
