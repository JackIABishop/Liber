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
import SVProgressHUD

class RegisterViewController: UIViewController {
    
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
    @IBAction func registerPressed(_ sender: AnyObject) {
        // Notify the user that something is happening.
        SVProgressHUD.show()
        
        // Set up a new user on the Firebase database.
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                //TODO: - If there is an error, ask the user to try again.
                print(error!)
                
                self.warningText.text = "Error registering account, please try again."
                                
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                    self.warningText.center.x += self.view.bounds.width
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
            } else {
                // Register successful.
                print("Registration Successful!")
                self.warningText.text = ""
                
                self.performSegue(withIdentifier: "goToGuideView", sender: self)
            }
            SVProgressHUD.dismiss()
        }
    }
}
