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
    
    // Linking text fields
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // Labels
    @IBOutlet var warningText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                    self.warningText.text = ""
                    self.performSegue(withIdentifier: "goToTabView", sender: self)
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
}

    

