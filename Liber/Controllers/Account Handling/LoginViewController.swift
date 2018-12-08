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
import SVProgressHUD

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
        SVProgressHUD.show()
        
        // Call Firebase with the user's login details.
        // As the function is called, I use a closure for the completion handler, so the app waits until the time consuming tasks is completed.
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            //TODO: - If there is an error, ask the user to try again.
            if error != nil {
                print(error!)
                self.warningText.text = "Wrong username or password."
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                    self.warningText.center.x += self.view.bounds.width
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                // Successful Login
                print("Log in successful")
                self.warningText.text = ""
                
                currentAccount.email = self.emailTextField.text!
                
                self.performSegue(withIdentifier: "goToTabView", sender: self)
            }
            SVProgressHUD.dismiss()
        }
    }
}
    

