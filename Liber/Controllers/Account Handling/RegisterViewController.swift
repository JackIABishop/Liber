//
//  RegisterViewController.swift
//  Liber
//
//  Created by Jack Bishop on 04/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class holds the logic for the Register View Controller.

import UIKit
import Firebase

class RegisterViewController: UIViewController {
  
  // Linking UI Elements.
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var confirmPasswordTextField: UITextField!
  @IBOutlet var warningText: UILabel!
  @IBOutlet weak var registerButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createGradientLayer(view: view)
    
    // Setting up button appearence.
    registerButton.layer.cornerRadius = 10
    registerButton.clipsToBounds = true
  }
  
  // MARK:- Account Handling
  @IBAction func registerPressed(_ sender: AnyObject) {
    // Notify the user that something is happening.
    indeterminateLoad(displayText: "Registering", view: self.view)
    
    // Set up a new user on the Firebase database.
    let registerParameters = ["Name": nameTextField.text! ,"Email": emailTextField.text!, "Password": passwordTextField.text!]
    if conductRegistrationValidation(registerParameters: registerParameters, confirmPassword: confirmPasswordTextField.text!) {
      registerFirebaseUser(registerParameters: registerParameters) { (result) in
        if result {
          hideHUD(view: self.view)
          // Successful registration.
          self.warningText.text = ""
          self.performSegue(withIdentifier: "goToGuideView", sender: self)
        } else {
          hideHUD(view: self.view)
          // Error registering with Firebase.
          self.warningText.text = "Error registering account, please try again."
        }
      }
    } else {
      hideHUD(view: self.view)
      // Register validation failed, so print an error message to the user.
      self.warningText.text = getLatestErrorMessageFromFirebaseFunctions()
    }
  }
}

