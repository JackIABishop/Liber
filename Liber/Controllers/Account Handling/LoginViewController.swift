//
//  LoginViewController.swift
//  Liber
//
//  Created by Jack Bishop on 04/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class holds the logic for the Login View Controller.

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // Linking UI Elements
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var warningText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer(view: view)
    }
    
    // MARK: - Account Handling
    @IBAction func logInPressed(_ sender: UIButton) {
        // Notify the user that an action is happening.
        indeterminateLoad(displayText: "Logging in", view: self.view)
        
        // Call Firebase with the user's login details.
        // As the function is called, I use a closure for the completion handler, so the app waits until the time consuming tasks is completed.
        let loginParameters = ["Email": emailTextField.text!, "Password": passwordTextField.text!]
        if conductLoginValidation(loginParameters: loginParameters) {
            signInFirebaseUser(loginParameters: loginParameters) { (result) in
                if result {
                    // Successful login
                    self.bookcasePurge { (_) in
                        // This will remove any bookcases that the user is subscribed too which has been deleted.
                        self.warningText.text = ""
                        self.performSegue(withIdentifier: "goToTabView", sender: self)
                    }
                } else {
                    // Error signing into Firebase.
                    self.warningText.text = "Incorrect email / password."
                }
            }
        } else {
            // Login validation failed, so print the error message to the user.
            self.warningText.text = getLatestErrorMessageFromFirebaseFunctions()
        }
        
        hideHUD(view: self.view)
    }
    
    func bookcasePurge(completion: @escaping (Bool) -> ()) {
        let subscribedDB = Database.database().reference().child("Users").child(organisationCode).child("Subscribed Organisations")
        
        // Go through each stored database and check if it is still has an account present.
        subscribedDB.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChildren() {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    let orgToSearch = snap.value as? String
                    
                    if orgToSearch == organisationCode {
                        // Users organisation, does not require checking
                    } else {
                        self.searchDatabaseForOrganisationUID(orgToCheck: snap, deleteCompletion: { (_) in
                            // Proceed
                        })
                    }
                }
                completion(true)
            }
        }
    }
    
    func searchDatabaseForOrganisationUID(orgToCheck: DataSnapshot, deleteCompletion: @escaping (Bool) -> ()) {
        let orgToSearch = orgToCheck.value as? String
        
        // Search through DBs.
        let databaseToSearch = Database.database().reference().child("Users")
        
        databaseToSearch.observeSingleEvent(of: .value, with: { (orgsnapshot) in
            if orgsnapshot.hasChildren() {
                for childUID in orgsnapshot.children {
                    let UIDsnap = childUID as! DataSnapshot
                    
                    // Check if UID exists, if not, delete from users database.
                    if UIDsnap.value as? String == orgToSearch {
                        // Do not delete
                        deleteCompletion(true)
                    } else {
                        // Cannot find, so delete
                        orgToCheck.ref.removeValue()
                        
                        deleteCompletion(true)
                    }
                }
            }
        })
    }
    
}

    

