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
  
  // Linking UI Elements.
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var warningText: UILabel!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.accessibilityIdentifier = "loginView" // Idenfitifier required to UI testing.
    createGradientLayer(view: view)
    
    // Setting up button appearence. 
    loginButton.layer.cornerRadius = 10
    loginButton.clipsToBounds = true
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
            hideHUD(view: self.view)
            // This will remove any bookcases that the user is subscribed too which has been deleted.
            self.warningText.text = ""
            self.performSegue(withIdentifier: "goToTabView", sender: self)
          }
        } else {
          hideHUD(view: self.view)
          // Error signing into Firebase.
          self.warningText.text = "Incorrect email / password."
        }
      }
    } else {
      hideHUD(view: self.view)
      // Login validation failed, so print the error message to the user.
      self.warningText.text = getLatestErrorMessageFromFirebaseFunctions()
    }
  }
  
  func bookcasePurge(completion: @escaping (Bool) -> Void) {
    let subscribedDB = Database.database().reference().child("Users").child(organisationCode).child("Subscribed Organisations")
    
    var subscribedOrganisations = [String]()
    
    // Go through each stored database and check if it is still has an account present.
    subscribedDB.observeSingleEvent(of: .value) { snapshot in
      if snapshot.hasChildren() {
        for child in snapshot.children {
          let snap = child as! DataSnapshot
          
          let orgToSearch = snap.value as? String
          
          subscribedOrganisations.append(orgToSearch!)
          
          print(orgToSearch!)
          
          if orgToSearch == organisationCode {
            // Users organisation, does not require checking.
          } else {
            // Check if orgToSearch exists in the identifier list.
            self.checkIfIDHasAnIdentifier(orgToSearch: orgToSearch!, result: { (result) in
              if !result {
                // There is no identifier, delete this entry.
                snap.ref.removeValue()
              }
            })
          }
        }
        completion(true)
      }
    }
  }
  
  func checkIfIDHasAnIdentifier(orgToSearch: String, result: @escaping (Bool) -> Void) {
    var orgFound: Bool = false
    
    // Search through DBs.
    //let databaseToSearch = Database.database().reference().child("Users")
    let databaseToSearch = Database.database().reference().child("Identifiers")
    
    databaseToSearch.observeSingleEvent(of: .value, with: { (orgsnapshot) in
      if orgsnapshot.hasChildren() {
        for childUID in orgsnapshot.children {
          let snap = childUID as! DataSnapshot
          let UIDSnap = snap.value as? String
          
          if UIDSnap! == orgToSearch {
            orgFound = true
          }
        }
        
        // Return false if the ID has not been found in the Identifiers list, notifying the caller to remove the value from the users Subscribed Organisations.
        if orgFound == false{
          result(false)
        }
      }
    })
  }
}




