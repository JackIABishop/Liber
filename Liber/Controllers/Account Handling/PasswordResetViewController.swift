//
//  PasswordResetViewController.swift
//  Liber
//
//  Created by Jack Bishop on 27/01/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  This class holds the logic for the Reset Password controller.

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {
  
  // Linking UI Elements
  @IBOutlet var confirmationText: UILabel!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet weak var resetButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createGradientLayer(view: view)
    
    // Setting up button appearence.
    resetButton.layer.cornerRadius = 10
    resetButton.clipsToBounds = true
  }
  
  @IBAction func resetPasswordPressed(_ sender: Any) {
    // Do email Validation.
    let usersEmail = emailTextField.text!
    
    if (!emailValidation(emailToTest: usersEmail)) {
      self.confirmationText.text = "Email not valid."
    }
    
    // If successful, send a password reset email.
    Auth.auth().sendPasswordReset(withEmail: usersEmail) { (error) in
      if error == nil {
        // Successful attempt
        self.confirmationText.text = "Check your inbox!"
      }
    }
  }
}

